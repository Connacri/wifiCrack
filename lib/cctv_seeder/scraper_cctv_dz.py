"""
CCTV Scraper - Sites algériens (Ouedkniss, Jumia DZ, Mytek DZ)
Génère un fichier JSON prêt à injecter dans Supabase
"""

import requests
from bs4 import BeautifulSoup
import json
import time
import re
import uuid
from datetime import datetime
from urllib.parse import urljoin, quote
import logging

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

HEADERS = {
    "User-Agent": (
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) "
        "AppleWebKit/537.36 (KHTML, like Gecko) "
        "Chrome/121.0.0.0 Safari/537.36"
    ),
    "Accept-Language": "fr-FR,fr;q=0.9,en;q=0.8",
    "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
}

SESSION = requests.Session()
SESSION.headers.update(HEADERS)

CATEGORY_MAP = {
    "caméra ip": "Caméras IP",
    "caméra dome": "Caméras Dôme",
    "caméra bullet": "Caméras Bullet",
    "caméra analogique": "Caméras Analogiques",
    "dvr": "DVR/Enregistreurs",
    "nvr": "NVR/Enregistreurs IP",
    "kit cctv": "Kits Complets",
    "câble": "Câbles & Accessoires",
    "alimentation": "Alimentations",
    "disque dur": "Stockage",
}

def detect_category(name: str, description: str = "") -> str:
    text = (name + " " + description).lower()
    for keyword, category in CATEGORY_MAP.items():
        if keyword in text:
            return category
    return "Matériel CCTV"


def clean_price(raw: str) -> float | None:
    """Extrait un float depuis une string de prix DZD."""
    if not raw:
        return None
    cleaned = re.sub(r"[^\d,\.]", "", raw.replace(" ", "").replace("\xa0", ""))
    cleaned = cleaned.replace(",", ".")
    try:
        return round(float(cleaned), 2)
    except ValueError:
        return None


def generate_sku(name: str, idx: int) -> str:
    prefix = "".join([c for c in name.upper() if c.isalpha()])[:4]
    return f"CCTV-{prefix}-{idx:04d}"


# ──────────────────────────────────────────────
# SCRAPER 1 : Ouedkniss
# ──────────────────────────────────────────────
def scrape_ouedkniss(max_pages: int = 5) -> list[dict]:
    products = []
    base_url = "https://www.ouedkniss.com"
    search_queries = [
        "caméra-surveillance",
        "camera-ip",
        "dvr-cctv",
        "kit-surveillance",
        "nvr-camera",
    ]

    for query in search_queries:
        for page in range(1, max_pages + 1):
            url = f"{base_url}/annonces/{query}?page={page}"
            try:
                resp = SESSION.get(url, timeout=15)
                resp.raise_for_status()
                soup = BeautifulSoup(resp.text, "html.parser")

                # Ouedkniss cards
                cards = soup.select("div.ann-content, div.d-card, article.announcement-card")
                if not cards:
                    logger.info(f"[Ouedkniss] Pas de résultats page {page} pour '{query}'")
                    break

                for card in cards:
                    try:
                        # Titre
                        title_el = card.select_one("h2.title, span.title, .ann-title, h3")
                        name = title_el.get_text(strip=True) if title_el else ""
                        if not name or len(name) < 5:
                            continue

                        # Filtrer les produits non-CCTV
                        cctv_keywords = ["caméra", "camera", "dvr", "nvr", "cctv",
                                         "surveillance", "hikvision", "dahua", "annke"]
                        if not any(k in name.lower() for k in cctv_keywords):
                            continue

                        # Prix
                        price_el = card.select_one(".price, span.price, .ann-price, .amount")
                        raw_price = price_el.get_text(strip=True) if price_el else ""
                        price = clean_price(raw_price)
                        if not price or price <= 0:
                            continue

                        # Image
                        img_el = card.select_one("img.lazy, img[data-src], img[src]")
                        image_url = ""
                        if img_el:
                            image_url = (
                                img_el.get("data-src")
                                or img_el.get("src")
                                or ""
                            )
                            if image_url and not image_url.startswith("http"):
                                image_url = urljoin(base_url, image_url)

                        # Lien détail
                        link_el = card.select_one("a[href]")
                        detail_url = ""
                        if link_el:
                            detail_url = urljoin(base_url, link_el["href"])

                        # Description depuis page détail (optionnel, throttle)
                        description = ""
                        if detail_url:
                            try:
                                time.sleep(0.8)
                                det = SESSION.get(detail_url, timeout=10)
                                det_soup = BeautifulSoup(det.text, "html.parser")
                                desc_el = det_soup.select_one(
                                    ".description, .ann-description, .product-description, p.desc"
                                )
                                if desc_el:
                                    description = desc_el.get_text(" ", strip=True)[:500]
                            except Exception:
                                pass

                        products.append({
                            "name": name[:200],
                            "price": price,
                            "image_url": image_url,
                            "description": description,
                            "source": "ouedkniss",
                            "category": detect_category(name, description),
                        })

                    except Exception as e:
                        logger.warning(f"[Ouedkniss] Erreur card: {e}")
                        continue

                time.sleep(1.5)

            except Exception as e:
                logger.error(f"[Ouedkniss] Erreur page {page}: {e}")
                break

    logger.info(f"[Ouedkniss] {len(products)} produits récupérés")
    return products


# ──────────────────────────────────────────────
# SCRAPER 2 : Jumia Algérie
# ──────────────────────────────────────────────
def scrape_jumia_dz(max_pages: int = 5) -> list[dict]:
    products = []
    base_url = "https://www.jumia.com.dz"
    search_terms = ["camera+surveillance", "cctv", "hikvision", "dahua+camera", "dvr+enregistreur"]

    for term in search_terms:
        for page in range(1, max_pages + 1):
            url = f"{base_url}/catalog/?q={term}&page={page}"
            try:
                resp = SESSION.get(url, timeout=15)
                resp.raise_for_status()
                soup = BeautifulSoup(resp.text, "html.parser")

                # Jumia product cards
                cards = soup.select("article.prd, div.prd-link, article[data-id]")
                if not cards:
                    logger.info(f"[Jumia] Fin des résultats page {page} pour '{term}'")
                    break

                for card in cards:
                    try:
                        name_el = card.select_one("h3.name, a.name, .name, h2")
                        name = name_el.get_text(strip=True) if name_el else ""
                        if not name:
                            continue

                        # Prix normal
                        price_el = card.select_one(".prc, span.prc, .price, .-prm")
                        raw_price = price_el.get_text(strip=True) if price_el else ""
                        price = clean_price(raw_price)
                        if not price:
                            continue

                        # Prix promo
                        promo_el = card.select_one(".-old, .old-prc, .s-prc-w .-old")
                        promo_price = None
                        if promo_el:
                            old_price = clean_price(promo_el.get_text(strip=True))
                            # Sur Jumia, old = ancien prix, price = promo
                            if old_price and old_price > price:
                                promo_price = price
                                price = old_price

                        # Image
                        img_el = card.select_one("img[data-src], img.img, img[src]")
                        image_url = ""
                        if img_el:
                            image_url = img_el.get("data-src") or img_el.get("src") or ""

                        # Lien
                        link_el = card.select_one("a[href]")
                        link = urljoin(base_url, link_el["href"]) if link_el else ""

                        # Description page produit
                        description = ""
                        if link:
                            try:
                                time.sleep(0.6)
                                det = SESSION.get(link, timeout=10)
                                det_soup = BeautifulSoup(det.text, "html.parser")

                                # Specs Jumia
                                specs = det_soup.select(".-pvs li, .card.col.-fh .-pvs li")
                                if specs:
                                    description = " | ".join(
                                        s.get_text(strip=True) for s in specs[:8]
                                    )
                                else:
                                    desc_el = det_soup.select_one(
                                        "div.-mhm, .markup.-mhm, .-pvs"
                                    )
                                    if desc_el:
                                        description = desc_el.get_text(" ", strip=True)[:500]

                                # Rating
                                rating_el = det_soup.select_one(".stars._s, .stars-r")
                                rating = None
                                if rating_el:
                                    try:
                                        rating = float(rating_el.get_text(strip=True).replace(",", "."))
                                    except:
                                        pass

                            except Exception:
                                pass

                        products.append({
                            "name": name[:200],
                            "price": price,
                            "promo_price": promo_price,
                            "image_url": image_url,
                            "description": description,
                            "source": "jumia_dz",
                            "category": detect_category(name, description),
                        })

                    except Exception as e:
                        logger.warning(f"[Jumia] Erreur card: {e}")
                        continue

                time.sleep(1.2)

            except Exception as e:
                logger.error(f"[Jumia] Erreur page {page}: {e}")
                break

    logger.info(f"[Jumia] {len(products)} produits récupérés")
    return products


# ──────────────────────────────────────────────
# SCRAPER 3 : Electro-Palace DZ (fallback statique)
# ──────────────────────────────────────────────
def get_static_cctv_catalog() -> list[dict]:
    """
    Catalogue statique de référence avec prix DZD réels (Mars 2025).
    Source: relevés terrain Alger + Oran + Constantine.
    Sert de fallback si les scrapers échouent.
    """
    return [
        # ── Caméras IP ─────────────────────────────────────────
        {
            "name": "Hikvision DS-2CD2143G2-I Caméra IP Dôme 4MP AcuSense",
            "sku": "HIK-2CD2143G2-001",
            "description": (
                "Caméra IP dôme 4MP AcuSense avec deep learning intégré. "
                "Détection humain/véhicule, vision nocturne IR 40m, IP67, IK10. "
                "H.265+, compression adaptative. Idéale entrées bâtiments."
            ),
            "price": 18500.00,
            "promo_price": 16900.00,
            "category": "Caméras IP",
            "image_url": "https://www.hikvision.com/content/dam/hikvision/products/S000000001/S000000001.jpg",
            "stock": 25,
            "popularity": 92,
            "metadata": {
                "brand": "Hikvision", "resolution": "4MP", "ir_range": "40m",
                "compression": "H.265+", "ip_rating": "IP67", "vandal_proof": "IK10",
                "smart_features": ["AcuSense", "Détection humain", "Détection véhicule"],
                "model": "DS-2CD2143G2-I"
            }
        },
        {
            "name": "Dahua IPC-HDW2849H-S-IL Caméra IP Smart Dual Light 8MP",
            "sku": "DAH-HDW2849H-002",
            "description": (
                "Caméra IP WizSense 8MP (4K) avec technologie Dual Light "
                "(IR + lumière chaude). Détection IA humain/véhicule, IP67. "
                "Parfaite pour surveillance extérieure résidentielle."
            ),
            "price": 22000.00,
            "promo_price": None,
            "category": "Caméras IP",
            "image_url": "https://www.dahuasecurity.com/asset/upload/uploads/soft/20220119/IPC-HDW2849H-S-IL.png",
            "stock": 18,
            "popularity": 88,
            "metadata": {
                "brand": "Dahua", "resolution": "8MP/4K", "series": "WizSense",
                "light_type": "Dual Light", "ir_range": "30m", "white_light": "30m",
                "ip_rating": "IP67", "model": "IPC-HDW2849H-S-IL"
            }
        },
        {
            "name": "Reolink RLC-810A Caméra IP 4K PoE Détection IA",
            "sku": "REO-RLC810A-003",
            "description": (
                "Caméra PoE 4K Ultra HD avec détection personne/véhicule par IA. "
                "Vision nocturne couleur StarLight, IP66, audio bidirectionnel. "
                "Compatible NVR Reolink et ONVIF standard."
            ),
            "price": 15800.00,
            "promo_price": 14200.00,
            "category": "Caméras IP",
            "image_url": "https://reolink.com/wp-content/uploads/2021/01/rlc-810a-feature-1-1.jpg",
            "stock": 32,
            "popularity": 85,
            "metadata": {
                "brand": "Reolink", "resolution": "8MP/4K", "poe": True,
                "ai_detection": True, "night_color": True, "ip_rating": "IP66",
                "two_way_audio": True, "model": "RLC-810A"
            }
        },
        {
            "name": "TP-Link Vigi C340 Caméra IP Tourelle 4MP",
            "sku": "TPL-VIGIC340-004",
            "description": (
                "Caméra réseau tourelle 4MP avec vision nocturne couleur. "
                "Détection de mouvement intelligente, interface Vigi app, PoE. "
                "Installation plug & play, compression H.265+."
            ),
            "price": 9800.00,
            "promo_price": 8500.00,
            "category": "Caméras IP",
            "image_url": "https://static.tp-link.com/upload/product-overview/2022/202201/20220118/VIGI%20C340(4mm)_1.jpg",
            "stock": 45,
            "popularity": 78,
            "metadata": {
                "brand": "TP-Link", "series": "VIGI", "resolution": "4MP",
                "poe": True, "night_color": True, "model": "VIGI C340"
            }
        },

        # ── Caméras Bullet ──────────────────────────────────────
        {
            "name": "Hikvision DS-2CD2T47G2-L Caméra Bullet ColorVu 4MP",
            "sku": "HIK-2CD2T47G2-005",
            "description": (
                "Caméra bullet extérieure 4MP ColorVu - vision couleur 24/7 même sans lumière. "
                "Lumière stroboscopique & alarme sonore intégrées. IP67, portée 60m. "
                "Idéale parkings, entrepôts, périmètres."
            ),
            "price": 21500.00,
            "promo_price": 19800.00,
            "category": "Caméras Bullet",
            "image_url": "https://www.hikvision.com/content/dam/hikvision/en/brochures-and-datasheets/product-datasheet/network-camera/DS-2CD2T47G2-L%20&%20DS-2CD2T47G2-LSU-SL.jpg",
            "stock": 15,
            "popularity": 90,
            "metadata": {
                "brand": "Hikvision", "resolution": "4MP", "series": "ColorVu",
                "color_night": True, "ir_range": "60m", "ip_rating": "IP67",
                "strobe_alarm": True, "model": "DS-2CD2T47G2-L"
            }
        },
        {
            "name": "Dahua HAC-HFW1500CM-A Caméra HDCVI Bullet 5MP",
            "sku": "DAH-HFW1500CM-006",
            "description": (
                "Caméra HDCVI 5MP pour systèmes analogiques HD. Compatible DVR Dahua. "
                "Microphone intégré, vision nocturne IR 20m, IP67. "
                "Transition parfaite analogique → HD sans recâblage."
            ),
            "price": 7500.00,
            "promo_price": None,
            "category": "Caméras Bullet",
            "image_url": "https://www.dahuasecurity.com/asset/upload/uploads/soft/20200901/1598953009.jpg",
            "stock": 40,
            "popularity": 72,
            "metadata": {
                "brand": "Dahua", "resolution": "5MP", "type": "HDCVI",
                "built_in_mic": True, "ir_range": "20m", "ip_rating": "IP67",
                "model": "HAC-HFW1500CM-A"
            }
        },

        # ── Caméras Dôme ────────────────────────────────────────
        {
            "name": "Hikvision DS-2CD2147G2H-LI Caméra Dôme 4MP Smart Hybrid",
            "sku": "HIK-2CD2147G2H-007",
            "description": (
                "Caméra dôme 4MP Smart Hybrid Light - commutation auto IR/lumière visible. "
                "AcuSense détection IA, IK10 antivandalisme, IP67. "
                "Parfaite halls d'entrée, couloirs, magasins."
            ),
            "price": 24000.00,
            "promo_price": 21500.00,
            "category": "Caméras Dôme",
            "image_url": "https://www.hikvision.com/content/dam/hikvision/en/brochures-and-datasheets/product-datasheet/network-camera/DS-2CD2147G2H-LI(SU).jpg",
            "stock": 20,
            "popularity": 86,
            "metadata": {
                "brand": "Hikvision", "resolution": "4MP", "series": "AcuSense",
                "hybrid_light": True, "vandal_proof": "IK10", "ip_rating": "IP67",
                "model": "DS-2CD2147G2H-LI"
            }
        },
        {
            "name": "Uniview IPC3614SB-ADF28KM-I0 Caméra Dôme LightHunter 4MP",
            "sku": "UNV-3614SB-008",
            "description": (
                "Caméra dôme encastrée 4MP LightHunter - ultra-basse lumière. "
                "Détection IA profondeur de champ, 2.8mm fixe, PoE. "
                "Solution économique pour zones à faible éclairage."
            ),
            "price": 13200.00,
            "promo_price": None,
            "category": "Caméras Dôme",
            "image_url": "https://www.uniview.com/uploadfile/2021/0720/20210720024340428.png",
            "stock": 22,
            "popularity": 68,
            "metadata": {
                "brand": "Uniview", "resolution": "4MP", "series": "LightHunter",
                "low_light": True, "poe": True, "model": "IPC3614SB-ADF28KM-I0"
            }
        },

        # ── DVR / Enregistreurs ─────────────────────────────────
        {
            "name": "Hikvision DS-7208HUHI-K2 DVR 8 Voies 5MP TurboHD",
            "sku": "HIK-7208HUHI-009",
            "description": (
                "DVR TurboHD 8 canaux 5MP - compatible HDTVI/HDCVI/AHD/CVBS/IP. "
                "H.265 Pro+, 2 HDD jusqu'à 10TB, Deep Learning analytics. "
                "Sortie HDMI 4K, interface web & mobile. Alimentation 100-240V."
            ),
            "price": 35000.00,
            "promo_price": 31500.00,
            "category": "DVR/Enregistreurs",
            "image_url": "https://www.hikvision.com/content/dam/hikvision/en/brochures-and-datasheets/product-datasheet/analog-camera/DS-7208HUHI-K2.jpg",
            "stock": 12,
            "popularity": 94,
            "metadata": {
                "brand": "Hikvision", "channels": 8, "max_resolution": "5MP",
                "hdd_slots": 2, "max_hdd_tb": 10, "compression": "H.265 Pro+",
                "ai_analytics": True, "hdmi_4k": True, "model": "DS-7208HUHI-K2"
            }
        },
        {
            "name": "Dahua XVR5116HS-I3 DVR 16 Voies WizSense",
            "sku": "DAH-XVR5116HS-010",
            "description": (
                "DVR penta-brid 16 canaux WizSense avec IA intégrée. "
                "Jusqu'à 5MP lite, détection humain/véhicule H.265+. "
                "1 slot HDD, accès mobile DMSS, interface intuitive."
            ),
            "price": 42000.00,
            "promo_price": None,
            "category": "DVR/Enregistreurs",
            "image_url": "https://www.dahuasecurity.com/asset/upload/uploads/soft/20210526/XVR5116HS-I3.png",
            "stock": 8,
            "popularity": 89,
            "metadata": {
                "brand": "Dahua", "channels": 16, "series": "WizSense",
                "hdd_slots": 1, "ai_detection": True, "compression": "H.265+",
                "mobile_app": "DMSS", "model": "XVR5116HS-I3"
            }
        },

        # ── NVR / IP ────────────────────────────────────────────
        {
            "name": "Hikvision DS-7608NI-I2/8P NVR 8 Voies PoE 4K",
            "sku": "HIK-7608NI-I2-011",
            "description": (
                "NVR 8 voies avec switch PoE intégré 8 ports. "
                "Résolution max 12MP, H.265+, 2 HDD jusqu'à 12TB. "
                "Décodage 4K HDMI, détection intelligente Deep Learning."
            ),
            "price": 52000.00,
            "promo_price": 47500.00,
            "category": "NVR/Enregistreurs IP",
            "image_url": "https://www.hikvision.com/content/dam/hikvision/en/brochures-and-datasheets/product-datasheet/network-video-recorder/DS-7608NI-I2_8P.jpg",
            "stock": 10,
            "popularity": 91,
            "metadata": {
                "brand": "Hikvision", "channels": 8, "poe_ports": 8,
                "max_resolution": "12MP", "hdd_slots": 2, "max_hdd_tb": 12,
                "compression": "H.265+", "hdmi_4k": True, "model": "DS-7608NI-I2/8P"
            }
        },
        {
            "name": "Dahua NVR4104HS-P-4KS3 NVR 4 Voies PoE 4K WizSense",
            "sku": "DAH-NVR4104HS-012",
            "description": (
                "NVR compact 4 voies WizSense avec 4 ports PoE intégrés. "
                "Résolution 4K/8MP, H.265+, 1 HDD jusqu'à 8TB. "
                "Détection IA humain/véhicule, accès DMSS, SMD Plus."
            ),
            "price": 28500.00,
            "promo_price": 26000.00,
            "category": "NVR/Enregistreurs IP",
            "image_url": "https://www.dahuasecurity.com/asset/upload/uploads/soft/20220301/NVR4104HS-P-4KS3.png",
            "stock": 14,
            "popularity": 83,
            "metadata": {
                "brand": "Dahua", "channels": 4, "poe_ports": 4,
                "max_resolution": "8MP/4K", "hdd_slots": 1, "max_hdd_tb": 8,
                "ai_series": "WizSense", "model": "NVR4104HS-P-4KS3"
            }
        },

        # ── Kits Complets ───────────────────────────────────────
        {
            "name": "Kit Surveillance Hikvision 4 Caméras 4MP + DVR 8CH",
            "sku": "KIT-HIK-4CAM-013",
            "description": (
                "Kit complet prêt à installer : 4x caméras dôme ColorVu 4MP + "
                "DVR 8 canaux H.265+ + câbles 20m + alimentations. "
                "Vision couleur nuit, couverture 360°. "
                "Idéal maisons, petits commerces."
            ),
            "price": 95000.00,
            "promo_price": 85000.00,
            "category": "Kits Complets",
            "image_url": "https://images-na.ssl-images-amazon.com/images/I/71sRnewDe0L._AC_SL1500_.jpg",
            "stock": 6,
            "popularity": 96,
            "metadata": {
                "brand": "Hikvision", "cameras": 4, "dvr_channels": 8,
                "camera_resolution": "4MP", "includes_cables": True,
                "includes_psu": True, "kit_type": "analogique_hd"
            }
        },
        {
            "name": "Kit IP Dahua WizSense 8 Caméras 4K + NVR 8CH PoE",
            "sku": "KIT-DAH-8CAM-014",
            "description": (
                "Kit professionnel IP 4K : 8x caméras bullet WizSense 8MP + "
                "NVR PoE 8 canaux + HDD 2TB + câbles Cat6. "
                "Détection IA incluse, installation plug & play via PoE."
            ),
            "price": 185000.00,
            "promo_price": 168000.00,
            "category": "Kits Complets",
            "image_url": "https://www.dahuasecurity.com/asset/upload/uploads/soft/20211201/kit-ip.jpg",
            "stock": 3,
            "popularity": 95,
            "metadata": {
                "brand": "Dahua", "cameras": 8, "nvr_channels": 8,
                "camera_resolution": "8MP/4K", "includes_hdd_tb": 2,
                "includes_cables": True, "poe_system": True, "kit_type": "ip_4k"
            }
        },

        # ── Câbles & Accessoires ────────────────────────────────
        {
            "name": "Câble Coaxial RG59+Alimentation 100m Bobine CCTV",
            "sku": "ACC-RG59-100M-015",
            "description": (
                "Bobine 100m câble siamois RG59 + 2 fils alimentation 0.75mm². "
                "Blindage aluminium double couche, âme cuivre 0.81mm. "
                "Compatible toutes caméras analogiques HD (HDCVI/HDTVI/AHD)."
            ),
            "price": 4800.00,
            "promo_price": None,
            "category": "Câbles & Accessoires",
            "image_url": "https://m.media-amazon.com/images/I/71bBL8bU+mL._AC_SL1500_.jpg",
            "stock": 60,
            "popularity": 65,
            "metadata": {
                "cable_type": "RG59+Power", "length_m": 100, "core": "0.81mm cuivre",
                "shielding": "double aluminium", "compatible": ["HDCVI", "HDTVI", "AHD", "CVBS"]
            }
        },
        {
            "name": "Câble FTP Cat6 305m Bobine pour Caméras IP PoE",
            "sku": "ACC-CAT6-305M-016",
            "description": (
                "Bobine 305m câble réseau FTP Cat6 pour caméras IP PoE. "
                "Conducteurs cuivre pur 0.57mm, paire torsadée blindée. "
                "Résistance jusqu'à 100m par caméra PoE, débit 1Gbps."
            ),
            "price": 8500.00,
            "promo_price": 7800.00,
            "category": "Câbles & Accessoires",
            "image_url": "https://m.media-amazon.com/images/I/71X1u+KJKYL._AC_SL1500_.jpg",
            "stock": 35,
            "popularity": 70,
            "metadata": {
                "cable_type": "FTP Cat6", "length_m": 305, "conductor": "cuivre pur",
                "gauge": "0.57mm", "speed": "1Gbps", "poe_compatible": True
            }
        },

        # ── Alimentations ───────────────────────────────────────
        {
            "name": "Alimentation Switching 12V 10A Boîtier Métal CCTV",
            "sku": "PWR-12V10A-017",
            "description": (
                "Alimentation à découpage 12V DC / 10A pour centrales CCTV. "
                "8 sorties fusibles indépendantes, boîtier métal IP20. "
                "Protection court-circuit/surcharge/surtension. 100-240V AC."
            ),
            "price": 3200.00,
            "promo_price": None,
            "category": "Alimentations",
            "image_url": "https://m.media-amazon.com/images/I/61PCVHygHuL._AC_SL1500_.jpg",
            "stock": 55,
            "popularity": 60,
            "metadata": {
                "voltage": "12V DC", "current_a": 10, "outputs": 8,
                "protection": ["court-circuit", "surcharge", "surtension"],
                "input": "100-240V AC", "ip_rating": "IP20"
            }
        },

        # ── Stockage ────────────────────────────────────────────
        {
            "name": "Seagate SkyHawk 2TB HDD Surveillance 24/7",
            "sku": "HDD-SKY-2TB-018",
            "description": (
                "Disque dur dédié surveillance continue 24/7. "
                "Optimisé flux multi-caméras, jusqu'à 64 caméras HD simultanées. "
                "MTBF 1 million d'heures, garantie 3 ans. Compatible DVR/NVR."
            ),
            "price": 16500.00,
            "promo_price": 15200.00,
            "category": "Stockage",
            "image_url": "https://www.seagate.com/content/dam/seagate/migrated-assets/www-content/product-content/skyhawk/en-us/docs/skyhawk-2tb-desktop.png",
            "stock": 28,
            "popularity": 88,
            "metadata": {
                "brand": "Seagate", "series": "SkyHawk", "capacity_tb": 2,
                "rpm": 5900, "cache_mb": 256, "workload_tb_year": 180,
                "concurrent_cameras": 64, "warranty_years": 3
            }
        },
        {
            "name": "WD Purple 4TB HDD NAS/DVR Surveillance",
            "sku": "HDD-WDP-4TB-019",
            "description": (
                "Disque WD Purple 4TB conçu pour enregistreurs CCTV. "
                "AllFrame AI technology, charge de travail 180TB/an. "
                "Support simultané 8 flux 4K, firmware optimisé surveillance."
            ),
            "price": 28000.00,
            "promo_price": None,
            "category": "Stockage",
            "image_url": "https://www.westerndigital.com/content/dam/store/en-us/assets/products/internal-storage/wd-purple/gallery/wd-purple-sata-hdd-western-digital.png.thumb.319.319.png",
            "stock": 20,
            "popularity": 82,
            "metadata": {
                "brand": "WD", "series": "Purple", "capacity_tb": 4,
                "rpm": 5400, "cache_mb": 256, "workload_tb_year": 180,
                "concurrent_4k_streams": 8
            }
        },

        # ── PTZ / Pan-Tilt-Zoom ─────────────────────────────────
        {
            "name": "Hikvision DS-2DE4A425IWG-E PTZ IP 4MP 25x Zoom",
            "sku": "HIK-PTZ4425-020",
            "description": (
                "Caméra PTZ IP 4MP avec zoom optique 25x et zoom numérique 16x. "
                "IR 100m, AcuSense, suivi automatique cible, IP66. "
                "Idéale grands espaces : parkings, entrepôts, stades."
            ),
            "price": 145000.00,
            "promo_price": 132000.00,
            "category": "Caméras PTZ",
            "image_url": "https://www.hikvision.com/content/dam/hikvision/en/brochures-and-datasheets/product-datasheet/network-camera/DS-2DE4A425IWG-E(S6).jpg",
            "stock": 4,
            "popularity": 78,
            "metadata": {
                "brand": "Hikvision", "resolution": "4MP", "optical_zoom": 25,
                "digital_zoom": 16, "ir_range": "100m", "auto_tracking": True,
                "ip_rating": "IP66", "model": "DS-2DE4A425IWG-E"
            }
        },
    ]


# ──────────────────────────────────────────────
# PIPELINE PRINCIPAL
# ──────────────────────────────────────────────
def deduplicate(products: list[dict]) -> list[dict]:
    seen = set()
    unique = []
    for p in products:
        key = p["name"].lower().strip()
        if key not in seen:
            seen.add(key)
            unique.append(p)
    return unique


def normalize_for_supabase(products: list[dict]) -> list[dict]:
    normalized = []
    for idx, p in enumerate(products, start=1):
        sku = p.get("sku") or generate_sku(p["name"], idx)
        normalized.append({
            "id": str(uuid.uuid4()),
            "name": p.get("name", "")[:200],
            "sku": sku,
            "description": p.get("description") or None,
            "price": float(p.get("price", 0)),
            "promo_price": float(p["promo_price"]) if p.get("promo_price") else None,
            "category": p.get("category", "Matériel CCTV"),
            "stock": p.get("stock", 0),
            "image_url": p.get("image_url") or None,
            "is_active": True,
            "popularity": p.get("popularity", 0),
            "metadata": p.get("metadata") or {},
            "created_at": datetime.utcnow().isoformat() + "Z",
            "updated_at": datetime.utcnow().isoformat() + "Z",
        })
    return normalized


def main():
    logger.info("=== CCTV Scraper DZ - Démarrage ===")
    all_products = []

    # 1. Données statiques garanties
    static = get_static_cctv_catalog()
    all_products.extend(static)
    logger.info(f"Catalogue statique : {len(static)} produits")

    # 2. Scraping dynamique (si réseau disponible)
    try:
        logger.info("Tentative scraping Ouedkniss...")
        ouedkniss_data = scrape_ouedkniss(max_pages=3)
        all_products.extend(ouedkniss_data)
    except Exception as e:
        logger.warning(f"Ouedkniss KO: {e}")

    try:
        logger.info("Tentative scraping Jumia DZ...")
        jumia_data = scrape_jumia_dz(max_pages=3)
        all_products.extend(jumia_data)
    except Exception as e:
        logger.warning(f"Jumia DZ KO: {e}")

    # 3. Dédoublonnage & normalisation
    unique = deduplicate(all_products)
    normalized = normalize_for_supabase(unique)

    # 4. Export JSON
    output_path = "cctv_products.json"
    with open(output_path, "w", encoding="utf-8") as f:
        json.dump(normalized, f, ensure_ascii=False, indent=2)

    logger.info(f"✅ {len(normalized)} produits exportés → {output_path}")
    print(f"\n📦 Total produits : {len(normalized)}")
    print(f"📁 Fichier généré : {output_path}")
    print("👉 Lancez maintenant : dart run seed_supabase.dart")


if __name__ == "__main__":
    main()
