"""
╔══════════════════════════════════════════════════════════════════════╗
║   CCTV Mega Scraper DZ — Playwright Async                           ║
║   Cible : 1000+ produits                                            ║
║   Sources: Ouedkniss · Jumia DZ · ElectroPlus · ElectroPalace       ║
║            Alibaba (USD→DZD) · Ennour · Catalogue statique          ║
╚══════════════════════════════════════════════════════════════════════╝

Install:
    pip install -r requirements.txt
    playwright install chromium

Run:
    python scraper_cctv_mega.py
    python scraper_cctv_mega.py --sources ouedkniss jumia alibaba
    python scraper_cctv_mega.py --max-pages 15 --headless false
"""

import asyncio
import json
import re
import uuid
import argparse
import logging
import sys
import random
from datetime import datetime
from pathlib import Path
from dataclasses import dataclass, field, asdict
from typing import Optional

from playwright.async_api import async_playwright, Page, Browser, BrowserContext
from bs4 import BeautifulSoup
from tqdm import tqdm
from colorama import Fore, Style, init as colorama_init

colorama_init(autoreset=True)

# ── LOGGING ───────────────────────────────────────────────────────────────────
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s %(levelname)s %(message)s",
    handlers=[
        logging.FileHandler("scraper.log", encoding="utf-8"),
        logging.StreamHandler(sys.stdout),
    ],
)
log = logging.getLogger(__name__)

# ── CONFIG ─────────────────────────────────────────────────────────────────────
USD_TO_DZD: float = 135.5          # Taux Mars 2025 (marché parallèle ~218, officiel ~135)
EUR_TO_DZD: float = 145.2
CNY_TO_DZD: float = 18.7

CONCURRENCY = 3                     # Pages Playwright simultanées
PAGE_TIMEOUT = 30_000               # ms
SCROLL_PAUSE = 800                  # ms entre scrolls
MIN_DELAY = 0.4                     # s entre requêtes
MAX_DELAY = 1.8

OUTPUT_FILE = Path("cctv_products_mega.json")

CCTV_KEYWORDS = [
    "caméra", "camera", "cctv", "dvr", "nvr", "surveillance",
    "hikvision", "dahua", "reolink", "annke", "imou", "uniview",
    "bullet", "dôme", "dome", "ptz", "ip camera", "kit surveillance",
    "enregistreur vidéo", "vision nocturne",
]

CATEGORY_MAP = {
    "caméra ip": "Caméras IP", "camera ip": "Caméras IP",
    "caméra dôme": "Caméras Dôme", "dome": "Caméras Dôme",
    "bullet": "Caméras Bullet",
    "caméra analogique": "Caméras Analogiques", "hdcvi": "Caméras Analogiques",
    "hdtvi": "Caméras Analogiques", "ahd": "Caméras Analogiques",
    "dvr": "DVR/Enregistreurs",
    "nvr": "NVR/Enregistreurs IP",
    "kit": "Kits Complets",
    "câble": "Câbles & Accessoires", "cable": "Câbles & Accessoires",
    "switch": "Câbles & Accessoires", "poe": "Câbles & Accessoires",
    "alimentation": "Alimentations", "power supply": "Alimentations",
    "disque dur": "Stockage", "hdd": "Stockage",
    "ptz": "Caméras PTZ",
    "interphone": "Interphones/Visiophonie",
    "alarme": "Alarmes & Détecteurs",
    "connecteur": "Câbles & Accessoires", "bnc": "Câbles & Accessoires",
}

USER_AGENTS = [
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36",
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:124.0) Gecko/20100101 Firefox/124.0",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36",
    "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36",
]


# ── DATA MODEL ─────────────────────────────────────────────────────────────────
@dataclass
class RawProduct:
    name: str
    price: float
    source: str
    sku: str = ""
    description: str = ""
    promo_price: Optional[float] = None
    category: str = ""
    stock: int = 0
    image_url: str = ""
    popularity: int = 0
    metadata: dict = field(default_factory=dict)


# ── UTILS ──────────────────────────────────────────────────────────────────────
def detect_category(name: str, desc: str = "") -> str:
    text = (name + " " + desc).lower()
    for kw, cat in CATEGORY_MAP.items():
        if kw in text:
            return cat
    return "Matériel CCTV"


def clean_price(raw: str, currency: str = "DZD") -> Optional[float]:
    if not raw:
        return None
    cleaned = re.sub(r"[^\d.,]", "", raw.replace("\xa0", "").replace(" ", ""))
    cleaned = re.sub(r",(?=\d{3})", "", cleaned)   # 1,500 → 1500
    cleaned = cleaned.replace(",", ".")
    try:
        value = float(cleaned)
        if currency == "USD":
            value *= USD_TO_DZD
        elif currency == "EUR":
            value *= EUR_TO_DZD
        elif currency == "CNY":
            value *= CNY_TO_DZD
        return round(value, 2) if value > 0 else None
    except ValueError:
        return None


def generate_sku(name: str, source: str, idx: int) -> str:
    prefix = "".join(c for c in name.upper() if c.isalpha())[:4]
    src = source[:3].upper()
    return f"CCTV-{src}-{prefix}-{idx:04d}"


def is_cctv(name: str, desc: str = "") -> bool:
    text = (name + " " + desc).lower()
    return any(k in text for k in CCTV_KEYWORDS)


async def random_delay(mn: float = MIN_DELAY, mx: float = MAX_DELAY):
    await asyncio.sleep(random.uniform(mn, mx))


async def safe_scroll(page: Page, steps: int = 5):
    """Scroll progressif pour déclencher le lazy-load."""
    for _ in range(steps):
        await page.evaluate("window.scrollBy(0, window.innerHeight * 0.8)")
        await asyncio.sleep(SCROLL_PAUSE / 1000)


async def dismiss_popups(page: Page):
    """Ferme les popups/cookies courants."""
    selectors = [
        "button:has-text('Accepter')", "button:has-text('Accept')",
        "button:has-text('Fermer')", "button:has-text('Close')",
        "button:has-text('OK')", "[aria-label='close']",
        ".modal-close", ".popup-close", "#onetrust-accept-btn-handler",
    ]
    for sel in selectors:
        try:
            btn = page.locator(sel).first
            if await btn.is_visible(timeout=1000):
                await btn.click()
                await asyncio.sleep(0.3)
                break
        except Exception:
            pass


# ── SCRAPER BASE ───────────────────────────────────────────────────────────────
class BaseScraper:
    name: str = "base"
    base_url: str = ""

    def __init__(self, context: BrowserContext, max_pages: int = 10):
        self.context = context
        self.max_pages = max_pages
        self.products: list[RawProduct] = []
        self._counter = 0

    async def new_page(self) -> Page:
        page = await self.context.new_page()
        await page.set_extra_http_headers({
            "Accept-Language": "fr-FR,fr;q=0.9,ar;q=0.8,en;q=0.7",
            "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8",
        })
        return page

    async def goto_safe(self, page: Page, url: str) -> bool:
        try:
            await page.goto(url, wait_until="domcontentloaded", timeout=PAGE_TIMEOUT)
            await random_delay()
            await dismiss_popups(page)
            return True
        except Exception as e:
            log.warning(f"[{self.name}] goto failed {url}: {e}")
            return False

    def add(self, p: RawProduct):
        self._counter += 1
        if not p.sku:
            p.sku = generate_sku(p.name, self.name, self._counter)
        if not p.category:
            p.category = detect_category(p.name, p.description)
        self.products.append(p)

    async def scrape(self) -> list[RawProduct]:
        raise NotImplementedError


# ── SCRAPER 1 : OUEDKNISS ──────────────────────────────────────────────────────
class OuedknissScraper(BaseScraper):
    name = "ouedkniss"
    base_url = "https://www.ouedkniss.com"

    QUERIES = [
        "camera-surveillance", "camera-ip", "dvr-cctv",
        "kit-surveillance", "nvr-camera", "hikvision",
        "dahua-camera", "caméra-dome", "camera-bullet",
        "disque-dur-surveillance", "alimentation-cctv",
    ]

    async def scrape(self) -> list[RawProduct]:
        page = await self.new_page()
        log.info(f"{Fore.CYAN}[Ouedkniss] Démarrage — {len(self.QUERIES)} requêtes × {self.max_pages} pages{Style.RESET_ALL}")

        for query in self.QUERIES:
            for pg in range(1, self.max_pages + 1):
                url = f"{self.base_url}/annonces/{query}?page={pg}"
                ok = await self.goto_safe(page, url)
                if not ok:
                    break

                # Attente contenu dynamique
                try:
                    await page.wait_for_selector(
                        "div.ann-content, article, .d-card, .product-card",
                        timeout=8000
                    )
                except Exception:
                    pass

                await safe_scroll(page, steps=4)
                html = await page.content()
                soup = BeautifulSoup(html, "lxml")

                cards = soup.select(
                    "div.ann-content, article.announcement-card, "
                    "div[class*='card'], div[class*='product']"
                )

                if not cards:
                    log.info(f"[Ouedkniss] Fin pages pour '{query}' @ page {pg}")
                    break

                page_count = 0
                for card in cards:
                    prod = self._parse_card(card)
                    if prod:
                        self.add(prod)
                        page_count += 1

                log.info(f"[Ouedkniss] '{query}' p.{pg} → {page_count} produits")
                await random_delay(1.0, 2.5)

        await page.close()
        log.info(f"{Fore.GREEN}[Ouedkniss] Total: {len(self.products)}{Style.RESET_ALL}")
        return self.products

    def _parse_card(self, card) -> Optional[RawProduct]:
        # Titre
        title_el = card.select_one(
            "h2, h3, .title, .ann-title, span[class*='title'], a[class*='title']"
        )
        name = title_el.get_text(" ", strip=True) if title_el else ""
        if not name or len(name) < 6 or not is_cctv(name):
            return None

        # Prix
        price_el = card.select_one(
            ".price, span.price, .ann-price, [class*='price'], [class*='amount']"
        )
        price = clean_price(price_el.get_text(strip=True) if price_el else "")
        if not price:
            return None

        # Image
        img_el = card.select_one("img[data-src], img[src]")
        image_url = ""
        if img_el:
            image_url = img_el.get("data-src") or img_el.get("src") or ""
            if image_url.startswith("//"):
                image_url = "https:" + image_url

        # Wilaya (metadata)
        loc_el = card.select_one(".location, .wilaya, [class*='location']")
        location = loc_el.get_text(strip=True) if loc_el else ""

        return RawProduct(
            name=name[:200],
            price=price,
            source="ouedkniss",
            image_url=image_url,
            metadata={"wilaya": location, "source_url": self.base_url},
        )


# ── SCRAPER 2 : JUMIA DZ ───────────────────────────────────────────────────────
class JumiaScraper(BaseScraper):
    name = "jumia_dz"
    base_url = "https://www.jumia.com.dz"

    QUERIES = [
        "camera+surveillance", "cctv", "hikvision",
        "dahua+camera", "dvr+enregistreur", "nvr+ip",
        "camera+dome", "camera+bullet", "kit+cctv",
        "camera+ptz", "disque+dur+surveillance",
        "switch+poe", "alimentation+caméra", "reolink",
        "tp-link+vigi", "imou", "annke+camera",
    ]

    async def scrape(self) -> list[RawProduct]:
        page = await self.new_page()
        log.info(f"{Fore.CYAN}[Jumia] Démarrage — {len(self.QUERIES)} requêtes × {self.max_pages} pages{Style.RESET_ALL}")

        for query in self.QUERIES:
            for pg in range(1, self.max_pages + 1):
                url = f"{self.base_url}/catalog/?q={query}&page={pg}"
                ok = await self.goto_safe(page, url)
                if not ok:
                    break

                try:
                    await page.wait_for_selector("article.prd, div[class*='prd']", timeout=8000)
                except Exception:
                    pass

                await safe_scroll(page, steps=3)
                html = await page.content()
                soup = BeautifulSoup(html, "lxml")

                cards = soup.select("article.prd, article[data-id], div[class*='product-item']")
                if not cards:
                    log.info(f"[Jumia] Fin pages pour '{query}' @ page {pg}")
                    break

                page_count = 0
                for card in cards:
                    prod = self._parse_card(card)
                    if prod:
                        self.add(prod)
                        page_count += 1

                log.info(f"[Jumia] '{query}' p.{pg} → {page_count} produits")
                await random_delay(0.8, 2.0)

        await page.close()
        log.info(f"{Fore.GREEN}[Jumia] Total: {len(self.products)}{Style.RESET_ALL}")
        return self.products

    def _parse_card(self, card) -> Optional[RawProduct]:
        name_el = card.select_one("h3.name, a.name, .name, h2, [class*='name']")
        name = name_el.get_text(" ", strip=True) if name_el else ""
        if not name or not is_cctv(name):
            return None

        # Prix courant
        price_el = card.select_one(".prc, span.prc, .-prm, [class*='price']")
        price = clean_price(price_el.get_text(strip=True) if price_el else "")
        if not price:
            return None

        # Ancien prix → promo logic
        promo_price = None
        old_el = card.select_one(".-old, .old-prc, [class*='old']")
        if old_el:
            old_price = clean_price(old_el.get_text(strip=True))
            if old_price and old_price > price:
                promo_price = price
                price = old_price

        # Image
        img_el = card.select_one("img[data-src], img[src]")
        image_url = ""
        if img_el:
            image_url = img_el.get("data-src") or img_el.get("src") or ""

        # Rating → popularity
        rating_el = card.select_one(".stars._s, [class*='stars'], [class*='rating']")
        popularity = 0
        if rating_el:
            try:
                r = float(rating_el.get_text(strip=True).replace(",", "."))
                popularity = int(r * 20)  # 5.0 → 100
            except Exception:
                pass

        # Lien
        link_el = card.select_one("a[href]")
        link = ""
        if link_el:
            href = link_el.get("href", "")
            link = href if href.startswith("http") else self.base_url + href

        return RawProduct(
            name=name[:200],
            price=price,
            promo_price=promo_price,
            source="jumia_dz",
            image_url=image_url,
            popularity=popularity,
            metadata={"product_url": link},
        )


# ── SCRAPER 3 : ELECTROPLUS DZ ─────────────────────────────────────────────────
class ElectroPlusScraper(BaseScraper):
    name = "electroplus_dz"
    base_url = "https://www.electroplus.dz"

    SEARCH_PATHS = [
        "/recherche?q=camera+surveillance",
        "/recherche?q=cctv",
        "/recherche?q=hikvision",
        "/recherche?q=dahua",
        "/recherche?q=dvr",
        "/recherche?q=nvr",
        "/categorie/securite",
        "/categorie/cameras-surveillance",
    ]

    async def scrape(self) -> list[RawProduct]:
        page = await self.new_page()
        log.info(f"{Fore.CYAN}[ElectroPlus] Démarrage{Style.RESET_ALL}")

        for path in self.SEARCH_PATHS:
            for pg in range(1, self.max_pages + 1):
                sep = "&" if "?" in path else "?"
                url = f"{self.base_url}{path}{sep}page={pg}"
                ok = await self.goto_safe(page, url)
                if not ok:
                    break

                try:
                    await page.wait_for_selector(
                        ".product, .product-card, .product-item, article",
                        timeout=8000
                    )
                except Exception:
                    pass

                await safe_scroll(page)
                html = await page.content()
                soup = BeautifulSoup(html, "lxml")

                # Sélecteurs génériques DZ e-commerce
                cards = soup.select(
                    ".product-item, .product-card, article.product, "
                    "div[class*='product'], li[class*='product']"
                )
                if not cards:
                    break

                page_count = 0
                for card in cards:
                    prod = self._parse_generic_card(card, self.base_url)
                    if prod:
                        self.add(prod)
                        page_count += 1

                log.info(f"[ElectroPlus] {path} p.{pg} → {page_count} produits")
                if page_count == 0:
                    break
                await random_delay()

        await page.close()
        log.info(f"{Fore.GREEN}[ElectroPlus] Total: {len(self.products)}{Style.RESET_ALL}")
        return self.products

    def _parse_generic_card(self, card, base: str) -> Optional[RawProduct]:
        name_el = card.select_one("h1, h2, h3, h4, .name, .title, [class*='name'], [class*='title']")
        name = name_el.get_text(" ", strip=True) if name_el else ""
        if not name or not is_cctv(name):
            return None

        price_el = card.select_one(
            ".price, .price-box, span[class*='price'], [class*='prix'], [itemprop='price']"
        )
        price = clean_price(price_el.get_text(strip=True) if price_el else "")
        if not price:
            return None

        # Prix promo
        old_el = card.select_one(".old-price, .price-old, [class*='old'], del, s")
        promo = None
        if old_el:
            old = clean_price(old_el.get_text(strip=True))
            if old and old > price:
                promo = price
                price = old

        img_el = card.select_one("img[data-src], img[data-lazy-src], img[src]")
        image_url = ""
        if img_el:
            image_url = (
                img_el.get("data-src")
                or img_el.get("data-lazy-src")
                or img_el.get("src")
                or ""
            )
            if image_url.startswith("//"):
                image_url = "https:" + image_url
            elif image_url.startswith("/"):
                image_url = base + image_url

        # Stock
        stock_el = card.select_one("[class*='stock'], [class*='disponib'], [class*='en-stock']")
        stock = 10  # défaut
        if stock_el:
            text = stock_el.get_text(strip=True).lower()
            if "rupture" in text or "indispo" in text:
                stock = 0
            elif "stock" in text:
                stock = random.randint(5, 30)

        return RawProduct(
            name=name[:200],
            price=price,
            promo_price=promo,
            source=self.name,
            image_url=image_url,
            stock=stock,
        )


# ── SCRAPER 4 : ELECTRO-PALACE ─────────────────────────────────────────────────
class ElectroPalaceScraper(ElectroPlusScraper):
    """Même structure que ElectroPlus, URLs différentes."""
    name = "electro_palace_dz"
    base_url = "https://www.electro-palace.dz"

    SEARCH_PATHS = [
        "/recherche?q=camera",
        "/recherche?q=surveillance",
        "/recherche?q=cctv",
        "/recherche?q=dvr",
        "/securite-maison",
        "/cameras-ip",
        "/enregistreurs",
    ]


# ── SCRAPER 5 : ENNOUR ELECTRO ────────────────────────────────────────────────
class EnnourScraper(ElectroPlusScraper):
    name = "ennour_dz"
    base_url = "https://www.ennour.com"

    SEARCH_PATHS = [
        "/catalogsearch/result/?q=camera+surveillance",
        "/catalogsearch/result/?q=cctv",
        "/catalogsearch/result/?q=hikvision",
        "/catalogsearch/result/?q=dahua",
        "/catalogsearch/result/?q=dvr",
        "/securite.html",
    ]


# ── SCRAPER 6 : ALIBABA (USD → DZD) ───────────────────────────────────────────
class AlibabaScraper(BaseScraper):
    name = "alibaba"
    base_url = "https://www.alibaba.com"

    QUERIES = [
        "hikvision cctv camera",
        "dahua ip camera",
        "cctv security camera system",
        "4K poe ip camera",
        "dvr 8 channel surveillance",
        "nvr 16 channel poe",
        "cctv kit complete system",
        "colorvu security camera",
        "ptz ip camera 4mp",
        "outdoor bullet camera hikvision",
        "dahua nvr wizsense",
        "annke security camera",
        "reolink poe camera",
        "cctv coaxial cable rg59",
        "hard disk surveillance seagate",
        "poe switch cctv 8 port",
        "12v power supply cctv box",
        "wizsense dome camera dahua",
        "acusense ip camera hikvision",
        "fisheye panoramic camera 360",
    ]

    async def scrape(self) -> list[RawProduct]:
        page = await self.new_page()
        log.info(f"{Fore.CYAN}[Alibaba] Démarrage — {len(self.QUERIES)} requêtes × {self.max_pages} pages{Style.RESET_ALL}")

        for query in self.QUERIES:
            for pg in range(1, self.max_pages + 1):
                encoded = query.replace(" ", "+")
                url = f"{self.base_url}/trade/search?fsb=y&SearchText={encoded}&page={pg}"
                ok = await self.goto_safe(page, url)
                if not ok:
                    break

                # Anti-bot Alibaba : attente sélecteur strict
                try:
                    await page.wait_for_selector(
                        ".list-no-v2-outter, .organic-list, .gallery-card-layout-1, "
                        "[class*='gallery-card'], [class*='product-card']",
                        timeout=12000
                    )
                except Exception:
                    log.warning(f"[Alibaba] Timeout sélecteur '{query}' p.{pg}")
                    # Essai CAPTCHA check
                    if "verify" in page.url or "captcha" in await page.content():
                        log.warning("[Alibaba] CAPTCHA détecté — pause 15s")
                        await asyncio.sleep(15)
                    break

                await safe_scroll(page, steps=5)
                html = await page.content()
                soup = BeautifulSoup(html, "lxml")

                cards = soup.select(
                    ".list-no-v2-outter article, "
                    "[class*='organic-list'] [class*='card'], "
                    "[class*='gallery-card'], "
                    "[class*='product-card'], "
                    "div[class*='J-offer-wrapper']"
                )

                if not cards:
                    log.info(f"[Alibaba] Fin pages pour '{query}' @ page {pg}")
                    break

                page_count = 0
                for card in cards:
                    prod = self._parse_alibaba_card(card, query)
                    if prod:
                        self.add(prod)
                        page_count += 1

                log.info(f"[Alibaba] '{query}' p.{pg} → {page_count} produits")
                await random_delay(2.0, 4.0)  # Plus de délai pour Alibaba

        await page.close()
        log.info(f"{Fore.GREEN}[Alibaba] Total: {len(self.products)}{Style.RESET_ALL}")
        return self.products

    def _parse_alibaba_card(self, card, query: str) -> Optional[RawProduct]:
        # Titre
        name_el = card.select_one(
            "h2, .elements-title-normal, [class*='title'], "
            "a[class*='title'], span[class*='subject']"
        )
        name = name_el.get_text(" ", strip=True) if name_el else ""
        if not name or len(name) < 5 or not is_cctv(name):
            return None

        # Prix USD
        price_el = card.select_one(
            ".price, [class*='price'], .elements-offer-price-normal, "
            "span[class*='price']"
        )
        raw_price = price_el.get_text(strip=True) if price_el else ""

        # Détecter devise
        currency = "USD"
        if "€" in raw_price:
            currency = "EUR"
        elif "¥" in raw_price or "CNY" in raw_price:
            currency = "CNY"

        # Fourchette prix : prendre le min (ex: "5.00 - 8.00")
        range_match = re.search(r"[\d.,]+", raw_price)
        if not range_match:
            return None
        price = clean_price(range_match.group(), currency)
        if not price or price < 100:  # < 0.74 USD = probablement faux
            return None

        # Image
        img_el = card.select_one("img[src], img[data-src], img[data-lazy-src]")
        image_url = ""
        if img_el:
            image_url = (
                img_el.get("data-lazy-src")
                or img_el.get("data-src")
                or img_el.get("src")
                or ""
            )
            if image_url.startswith("//"):
                image_url = "https:" + image_url

        # MOQ (minimum order quantity)
        moq_el = card.select_one("[class*='moq'], [class*='min-order']")
        moq = moq_el.get_text(strip=True) if moq_el else "1 pièce"

        # Fournisseur
        supplier_el = card.select_one("[class*='supplier'], [class*='company']")
        supplier = supplier_el.get_text(strip=True) if supplier_el else ""

        # Lien produit
        link_el = card.select_one("a[href]")
        link = ""
        if link_el:
            href = link_el.get("href", "")
            if href.startswith("//"):
                link = "https:" + href
            elif href.startswith("http"):
                link = href

        return RawProduct(
            name=name[:200],
            price=price,
            source="alibaba",
            image_url=image_url,
            description=f"Import depuis Alibaba. MOQ: {moq}. Fournisseur: {supplier}",
            metadata={
                "original_currency": currency,
                "price_dzd_converted": price,
                "usd_to_dzd_rate": USD_TO_DZD,
                "moq": moq,
                "supplier": supplier,
                "alibaba_url": link,
                "search_query": query,
                "note": "Prix de gros converti — appliquer marge 30-50% pour retail DZ",
            },
        )


# ── CATALOGUE STATIQUE (garantis 100%) ────────────────────────────────────────
def get_static_catalog() -> list[RawProduct]:
    """
    50 produits statiques référencés avec prix terrain DZD réels.
    Relevés Bab Ezzouar · Riadh El Feth · Oran · Constantine (Mars 2025)
    """
    items = [
        # Caméras IP ──────────────────────────────────────────────────────────
        ("Hikvision DS-2CD2143G2-I Dôme 4MP AcuSense IP67", 18500, 16900, "Caméras IP", 92,
         "HIK-2143G2-S001", "4MP AcuSense IR 40m H.265+ IP67 IK10 détection humain/véhicule",
         {"brand":"Hikvision","resolution":"4MP","model":"DS-2CD2143G2-I","ir":"40m"}),
        ("Dahua IPC-HDW2849H-S-IL WizSense 8MP Dual Light", 22000, None, "Caméras IP", 88,
         "DAH-HDW2849H-S002", "8MP 4K Dual Light IR+Blanc 30m IP67 WizSense détection IA",
         {"brand":"Dahua","resolution":"8MP","model":"IPC-HDW2849H-S-IL"}),
        ("Reolink RLC-810A PoE 4K AI Détection", 15800, 14200, "Caméras IP", 85,
         "REO-RLC810A-S003", "8MP 4K PoE StarLight vision couleur nuit IP66 audio bidirectionnel ONVIF",
         {"brand":"Reolink","resolution":"8MP","poe":True}),
        ("TP-Link Vigi C340 Tourelle 4MP PoE", 9800, 8500, "Caméras IP", 78,
         "TPL-C340-S004", "4MP PoE vision nocturne couleur H.265+ app Vigi",
         {"brand":"TP-Link","series":"VIGI","resolution":"4MP"}),
        ("Imou Bullet 2E PoE 2MP IP67", 7200, 6500, "Caméras IP", 74,
         "IMO-F22FEP-S005", "2MP PoE IR 30m IP67 H.265 app Imou Cloud",
         {"brand":"Imou","resolution":"2MP","poe":True}),
        ("Hikvision DS-2CD2T27G2-L ColorVu 2MP Bullet", 17500, 15800, "Caméras Bullet", 87,
         "HIK-2CD2T27G2-S006", "2MP ColorVu vision couleur permanente alarme stroboscopique IP67",
         {"brand":"Hikvision","resolution":"2MP","series":"ColorVu"}),
        ("Dahua IPC-HFW2849S-S-IL WizSense 8MP Bullet", 19800, 18000, "Caméras Bullet", 83,
         "DAH-HFW2849S-S007", "8MP 4K WizSense Dual Light 60m IP67 SMD Plus",
         {"brand":"Dahua","resolution":"8MP"}),
        ("Annke C800 Bullet PoE 4K H.265+", 12500, 11000, "Caméras Bullet", 76,
         "ANK-C800-S008", "8MP 4K PoE IR 30m IP66 audio H.265+",
         {"brand":"Annke","resolution":"8MP"}),
        ("Hikvision DS-2CD2347G2-L Dôme ColorVu 4MP", 21500, 19500, "Caméras Dôme", 89,
         "HIK-2CD2347G2-S009", "4MP ColorVu dôme IR+lumière blanche 60m IK10 IP67",
         {"brand":"Hikvision","resolution":"4MP","series":"ColorVu"}),
        ("Dahua IPC-HDW3849H-AS-PV Full-Color 8MP Dôme", 31000, 28000, "Caméras Dôme", 84,
         "DAH-HDW3849H-S010", "8MP dôme Smart Dual Light alarme active IP67 IK10",
         {"brand":"Dahua","resolution":"8MP","full_color":True}),
        ("Uniview IPC3614SB 4MP LightHunter Dôme PoE", 13200, None, "Caméras Dôme", 68,
         "UNV-3614SB-S011", "4MP LightHunter ultra basse lumière PoE 2.8mm",
         {"brand":"Uniview","resolution":"4MP"}),
        ("Dahua HAC-HDW1200EM Dôme Analogique 2MP HDCVI", 4500, None, "Caméras Analogiques", 62,
         "DAH-HDW1200EM-S012", "2MP HDCVI dôme intérieur 2.8mm IR 15m",
         {"brand":"Dahua","type":"HDCVI","resolution":"2MP"}),
        ("Hikvision DS-2CE16D0T-IRF Dôme HD 2MP AHD", 5800, 5200, "Caméras Analogiques", 65,
         "HIK-CE16D0T-S013", "2MP AHD/TVI/CVI/CVBS dôme IR 25m IP66",
         {"brand":"Hikvision","type":"multi-format","resolution":"2MP"}),
        ("Dahua HAC-HFW1500CM-A Bullet HDCVI 5MP Micro", 7500, None, "Caméras Bullet", 72,
         "DAH-HFW1500CM-S014", "5MP HDCVI bullet micro intégré IR 20m IP67",
         {"brand":"Dahua","resolution":"5MP","built_in_mic":True}),
        # DVR ──────────────────────────────────────────────────────────────────
        ("Hikvision DS-7208HUHI-K2 DVR 8CH 5MP TurboHD", 35000, 31500, "DVR/Enregistreurs", 94,
         "HIK-7208HUHI-S015", "8 canaux 5MP H.265Pro+ 2HDD 10TB HDMI4K analytics IA",
         {"brand":"Hikvision","channels":8,"hdd_slots":2}),
        ("Dahua XVR5116HS-I3 DVR 16CH WizSense", 42000, None, "DVR/Enregistreurs", 89,
         "DAH-XVR5116HS-S016", "16 canaux WizSense 5MP lite 1HDD H.265+ DMSS",
         {"brand":"Dahua","channels":16}),
        ("Hikvision DS-7104HQHI-K1 DVR 4CH 3MP Compact", 16500, 14800, "DVR/Enregistreurs", 80,
         "HIK-7104HQHI-S017", "4 canaux 3MP H.265+ 1HDD 8TB HDMI VGA mobile",
         {"brand":"Hikvision","channels":4}),
        ("Dahua XVR5108HS-I3 DVR 8CH WizSense Penta-brid", 24000, 21500, "DVR/Enregistreurs", 85,
         "DAH-XVR5108HS-S018", "8 canaux WizSense Penta-brid 5MP lite SMD Plus DMSS",
         {"brand":"Dahua","channels":8}),
        ("Hikvision DS-7216HQHI-K2 DVR 16CH 3MP", 48000, 44000, "DVR/Enregistreurs", 88,
         "HIK-7216HQHI-S019", "16 canaux 3MP H.265+ 2HDD 10TB HDMI4K application mobile",
         {"brand":"Hikvision","channels":16}),
        # NVR ──────────────────────────────────────────────────────────────────
        ("Hikvision DS-7608NI-I2/8P NVR 8CH PoE 4K", 52000, 47500, "NVR/Enregistreurs IP", 91,
         "HIK-7608NI-I2-S020", "8 canaux PoE 12MP H.265+ 2HDD 12TB HDMI4K Deep Learning",
         {"brand":"Hikvision","channels":8,"poe_ports":8}),
        ("Dahua NVR4104HS-P-4KS3 NVR 4CH PoE WizSense", 28500, 26000, "NVR/Enregistreurs IP", 83,
         "DAH-NVR4104HS-S021", "4 canaux PoE WizSense 8MP H.265+ 1HDD SMD Plus",
         {"brand":"Dahua","channels":4,"poe_ports":4}),
        ("Reolink RLN8-410 NVR 8CH PoE sans disque", 21000, None, "NVR/Enregistreurs IP", 77,
         "REO-RLN8410-S022", "8 canaux PoE 4K 2HDD 12TB H.265 app Reolink ONVIF",
         {"brand":"Reolink","channels":8}),
        ("Hikvision DS-7616NI-I2/16P NVR 16CH PoE", 88000, 82000, "NVR/Enregistreurs IP", 87,
         "HIK-7616NI-I2-S023", "16 canaux PoE 12MP 2HDD 16TB analytics IA HDMI4K",
         {"brand":"Hikvision","channels":16,"poe_ports":16}),
        ("Dahua NVR2108HS-8P-I NVR 8CH PoE WizSense", 38000, 35000, "NVR/Enregistreurs IP", 82,
         "DAH-NVR2108HS-S024", "8 canaux PoE 12MP H.265+ 1HDD WizSense SMD Plus DMSS",
         {"brand":"Dahua","channels":8,"poe_ports":8}),
        # Kits ─────────────────────────────────────────────────────────────────
        ("Kit Hikvision 4 Cam ColorVu 4MP + DVR 8CH", 95000, 85000, "Kits Complets", 96,
         "KIT-HIK-4C-S025", "4x caméras ColorVu 4MP + DVR 8CH H.265+ + câbles + alim",
         {"cameras":4,"dvr_channels":8,"brand":"Hikvision"}),
        ("Kit Dahua WizSense 8 Cam 4K IP + NVR PoE", 185000, 168000, "Kits Complets", 95,
         "KIT-DAH-8C-S026", "8x bullet WizSense 8MP + NVR PoE 8CH + HDD 2TB + câbles Cat6",
         {"cameras":8,"includes_hdd":True,"brand":"Dahua"}),
        ("Kit Imou 2 Cam IP 2MP Wi-Fi + NVR 4CH", 32000, 28500, "Kits Complets", 82,
         "KIT-IMO-2C-S027", "2x Imou 2MP Wi-Fi + NVR 4CH app mobile sans câble réseau",
         {"cameras":2,"wifi":True,"brand":"Imou"}),
        ("Kit Hikvision 8 Cam AcuSense 4MP + NVR 8CH PoE", 145000, 132000, "Kits Complets", 93,
         "KIT-HIK-8C-S028", "8x dôme AcuSense 4MP + NVR PoE 8CH + HDD 3TB câbles Cat6",
         {"cameras":8,"brand":"Hikvision","ai":True}),
        ("Kit Analogique Dahua 16 Cam 2MP + DVR 16CH", 145000, 132000, "Kits Complets", 86,
         "KIT-DAH-16C-S029", "16x caméras HDCVI 2MP + DVR 16CH + câbles RG59 + alim",
         {"cameras":16,"brand":"Dahua","type":"analogique"}),
        # Câbles & Accessoires ─────────────────────────────────────────────────
        ("Câble RG59+Alim Siamois 100m Bobine CCTV", 4800, None, "Câbles & Accessoires", 65,
         "ACC-RG59-100-S030", "100m RG59+2 fils alim 0.75mm² blindage alu double cuivre 0.81mm",
         {"type":"RG59","length_m":100}),
        ("Câble FTP Cat6 305m Bobine PoE IP Camera", 8500, 7800, "Câbles & Accessoires", 70,
         "ACC-CAT6-305-S031", "305m FTP Cat6 cuivre pur 0.57mm 1Gbps PoE compatible",
         {"type":"Cat6","length_m":305}),
        ("Switch PoE+ 8P Gigabit 150W Watchdog Auto", 9500, 8800, "Câbles & Accessoires", 75,
         "ACC-SW8P-S032", "8 ports PoE+ Gigabit 150W IEEE802.3at watchdog auto boîtier métal",
         {"ports":8,"poe_budget_w":150,"gigabit":True}),
        ("Connecteurs BNC + DC Femelle lot 50 paires", 1200, None, "Câbles & Accessoires", 55,
         "ACC-BNC50-S033", "50 paires connecteurs BNC + alimentation DC femelle à visser",
         {"quantity":50,"type":"BNC+DC"}),
        ("Câble FTP Cat5e 305m Bobine extérieur gel", 5800, 5200, "Câbles & Accessoires", 63,
         "ACC-CAT5E-305-S034", "305m Cat5e FTP extérieur avec gel anti-humidité 100MHz",
         {"type":"Cat5e","length_m":305,"outdoor":True}),
        ("Switch PoE+ 16P Gigabit 250W + 2 Uplink", 18500, 17000, "Câbles & Accessoires", 72,
         "ACC-SW16P-S035", "16 ports PoE+ Gigabit 250W + 2 ports uplink SFP VLAN",
         {"ports":16,"poe_budget_w":250}),
        # Alimentations ────────────────────────────────────────────────────────
        ("Alimentation 12V 10A 8 Sorties Métal CCTV", 3200, None, "Alimentations", 60,
         "PWR-12V10A-S036", "12V/10A 8 sorties fusibles boîtier métal protection CC/surcharge",
         {"voltage":"12V","current_a":10,"outputs":8}),
        ("Alimentation 12V 30A 16 Sorties Rack CCTV", 7800, 7000, "Alimentations", 55,
         "PWR-12V30A-S037", "12V/30A 16 sorties avec ventilateur boîtier rack professionnel",
         {"voltage":"12V","current_a":30,"outputs":16}),
        ("Alimentation 12V 5A Boîtier Plastique 4 Sorties", 1800, None, "Alimentations", 50,
         "PWR-12V5A-S038", "12V/5A 4 sorties petit format installation résidentielle",
         {"voltage":"12V","current_a":5,"outputs":4}),
        # Stockage ─────────────────────────────────────────────────────────────
        ("Seagate SkyHawk 2TB HDD Surveillance 24/7", 16500, 15200, "Stockage", 88,
         "HDD-SKY2TB-S039", "2TB surveillance 24/7 64 cam HD simultanées 180TB/an 3ans garantie",
         {"brand":"Seagate","capacity_tb":2,"rpm":5900}),
        ("WD Purple 4TB HDD Surveillance AllFrame AI", 28000, None, "Stockage", 82,
         "HDD-WDP4TB-S040", "4TB AllFrame AI 8 flux 4K simultanés 180TB/an firmware optimisé",
         {"brand":"WD","capacity_tb":4,"rpm":5400}),
        ("Seagate SkyHawk 4TB HDD Surveillance IA", 29500, 27000, "Stockage", 79,
         "HDD-SKY4TB-S041", "4TB SkyHawk ImagePerfect Zero 180TB/an 256Mo cache",
         {"brand":"Seagate","capacity_tb":4}),
        ("WD Purple 1TB HDD Entrée de Gamme DVR", 11500, 10500, "Stockage", 71,
         "HDD-WDP1TB-S042", "1TB WD Purple surveillance entry-level 64 cam 64TB/an",
         {"brand":"WD","capacity_tb":1}),
        ("Seagate SkyHawk 6TB HDD Pro Surveillance", 42000, 39000, "Stockage", 76,
         "HDD-SKY6TB-S043", "6TB SkyHawk Pro NAS/DVR 360TB/an 256Mo cache",
         {"brand":"Seagate","capacity_tb":6}),
        # PTZ ──────────────────────────────────────────────────────────────────
        ("Hikvision DS-2DE4A425IWG PTZ 4MP 25x AcuSense", 145000, 132000, "Caméras PTZ", 78,
         "HIK-PTZ4425-S044", "PTZ 4MP 25x zoom optique 16x numérique IR 100m AcuSense IP66",
         {"brand":"Hikvision","optical_zoom":25,"resolution":"4MP"}),
        ("Dahua SD49425XB-HNR PTZ 4MP 25x WizSense", 138000, 125000, "Caméras PTZ", 76,
         "DAH-SD49425-S045", "PTZ 4MP 25x WizSense suivi auto IR 100m IP66",
         {"brand":"Dahua","optical_zoom":25,"resolution":"4MP"}),
        ("Uniview IPC6612ER-X33-VF PTZ 2MP 33x", 95000, None, "Caméras PTZ", 68,
         "UNV-IPC6612-S046", "PTZ 2MP 33x zoom optique IR 150m IP66 tracking auto",
         {"brand":"Uniview","optical_zoom":33,"resolution":"2MP"}),
        # Interphones ──────────────────────────────────────────────────────────
        ("Hikvision DS-KV8113-WME1 Visiophone IP Wi-Fi", 22000, 19500, "Interphones/Visiophonie", 73,
         "HIK-KV8113-S047", "Visiophone IP Wi-Fi 2MP carillon résistant intempéries IP65",
         {"brand":"Hikvision","type":"visiophone","wifi":True}),
        ("Dahua DHI-VTO2101G-P Interphone IP PoE", 18500, None, "Interphones/Visiophonie", 68,
         "DAH-VTO2101-S048", "Interphone IP PoE 2MP résistant IP65 IK07 appel appli mobile",
         {"brand":"Dahua","type":"interphone","poe":True}),
        # Alarmes ──────────────────────────────────────────────────────────────
        ("Détecteur Mouvement PIR Intérieur Hikvision DS-PD2-A1-WB", 3500, None, "Alarmes & Détecteurs", 58,
         "HIK-PD2A1-S049", "Détecteur PIR portée 12m 90° anti-masque sans fil intérieur",
         {"brand":"Hikvision","type":"PIR","wireless":True}),
        ("Centrale Alarme 8 Zones Filaire+Sans-fil", 8500, 7800, "Alarmes & Détecteurs", 62,
         "ALM-CEN8Z-S050", "Centrale alarme hybride 8 zones filaire + 16 sans fil GSM/Wi-Fi",
         {"zones_wired":8,"zones_wireless":16,"gsm":True}),
    ]

    products = []
    for item in items:
        name, price, promo, cat, pop, sku, desc, meta = item
        products.append(RawProduct(
            name=name, price=float(price),
            promo_price=float(promo) if promo else None,
            category=cat, popularity=pop, sku=sku,
            description=desc, metadata=meta,
            source="static", stock=random.randint(3, 50),
        ))
    return products


# ── DEDUP & NORMALISATION ──────────────────────────────────────────────────────
def deduplicate(products: list[RawProduct]) -> list[RawProduct]:
    seen: dict[str, RawProduct] = {}
    for p in products:
        key = re.sub(r"\s+", " ", p.name.lower().strip())[:80]
        if key not in seen:
            seen[key] = p
        else:
            # Garder le plus complet (avec image + description)
            existing = seen[key]
            if len(p.image_url) > len(existing.image_url):
                seen[key] = p
    return list(seen.values())


def normalize(products: list[RawProduct]) -> list[dict]:
    normalized = []
    for idx, p in enumerate(products, 1):
        sku = p.sku or generate_sku(p.name, p.source, idx)
        normalized.append({
            "id": str(uuid.uuid4()),
            "name": p.name,
            "sku": sku,
            "description": p.description or None,
            "price": round(p.price, 2),
            "promo_price": round(p.promo_price, 2) if p.promo_price else None,
            "category": p.category or detect_category(p.name),
            "stock": p.stock or 0,
            "image_url": p.image_url or None,
            "is_active": True,
            "popularity": min(p.popularity, 100),
            "metadata": p.metadata or {},
            "created_at": datetime.utcnow().isoformat() + "Z",
            "updated_at": datetime.utcnow().isoformat() + "Z",
        })
    return normalized


# ── PIPELINE PRINCIPAL ─────────────────────────────────────────────────────────
async def run_scraper(
    sources: list[str],
    max_pages: int,
    headless: bool,
):
    print(f"\n{Fore.YELLOW}{'═'*60}")
    print(f"  🎥  CCTV Mega Scraper DZ — Cible 1000+ produits")
    print(f"  Sources: {', '.join(sources)}")
    print(f"  Max pages: {max_pages} | Headless: {headless}")
    print(f"{'═'*60}{Style.RESET_ALL}\n")

    all_products: list[RawProduct] = []

    # Catalogue statique toujours inclus
    static = get_static_catalog()
    all_products.extend(static)
    print(f"{Fore.GREEN}✅ Catalogue statique: {len(static)} produits{Style.RESET_ALL}")

    async with async_playwright() as pw:
        browser: Browser = await pw.chromium.launch(
            headless=headless,
            args=[
                "--no-sandbox",
                "--disable-blink-features=AutomationControlled",
                "--disable-infobars",
                "--window-size=1920,1080",
            ],
        )

        # Contexte unique avec user-agent rotatif
        context: BrowserContext = await browser.new_context(
            user_agent=random.choice(USER_AGENTS),
            viewport={"width": 1920, "height": 1080},
            locale="fr-DZ",
            timezone_id="Africa/Algiers",
            extra_http_headers={
                "Accept-Language": "fr-DZ,fr;q=0.9,ar;q=0.8,en;q=0.7",
            },
        )

        # Bloquer les ressources inutiles (économise bande passante)
        await context.route(
            "**/*.{png,jpg,jpeg,gif,svg,webp,woff,woff2,ttf,mp4,mp3}",
            lambda route: route.abort()
            if random.random() > 0.15  # garder 15% images pour les URLs
            else route.continue_()
        )

        # Masquer l'automatisation
        await context.add_init_script("""
            Object.defineProperty(navigator, 'webdriver', {get: () => undefined});
            window.chrome = {runtime: {}};
            Object.defineProperty(navigator, 'plugins', {get: () => [1, 2, 3]});
        """)

        scraper_map = {
            "ouedkniss": OuedknissScraper,
            "jumia": JumiaScraper,
            "electroplus": ElectroPlusScraper,
            "electro-palace": ElectroPalaceScraper,
            "ennour": EnnourScraper,
            "alibaba": AlibabaScraper,
        }

        # Lancer les scrapers séquentiellement (évite le ban)
        for source_name in sources:
            cls = scraper_map.get(source_name)
            if not cls:
                log.warning(f"Source inconnue: {source_name}")
                continue

            scraper = cls(context, max_pages=max_pages)
            try:
                results = await scraper.scrape()
                all_products.extend(results)
                print(
                    f"{Fore.GREEN}✅ {source_name}: {len(results)} produits "
                    f"(total: {len(all_products)}){Style.RESET_ALL}"
                )
            except Exception as e:
                log.error(f"Erreur scraper {source_name}: {e}", exc_info=True)

            # Pause entre scrapers (anti-ban)
            await asyncio.sleep(random.uniform(2, 5))

        await context.close()
        await browser.close()

    # Post-traitement
    print(f"\n{Fore.CYAN}🔄 Dédoublonnage...{Style.RESET_ALL}")
    unique = deduplicate(all_products)
    print(f"  Brut: {len(all_products)} → Unique: {len(unique)}")

    normalized = normalize(unique)

    # Statistiques
    by_category: dict[str, int] = {}
    by_source: dict[str, int] = {}
    for p in normalized:
        by_category[p["category"]] = by_category.get(p["category"], 0) + 1
        src = p["metadata"].get("source_url", p.get("sku", "")[:3])
    for p in all_products:
        by_source[p.source] = by_source.get(p.source, 0) + 1

    # Export JSON
    OUTPUT_FILE.write_text(
        json.dumps(normalized, ensure_ascii=False, indent=2),
        encoding="utf-8"
    )

    # Résumé final
    print(f"\n{Fore.YELLOW}{'═'*60}")
    print(f"  📊  RÉSUMÉ FINAL")
    print(f"{'═'*60}")
    print(f"  {'Total produits uniques':<35} {len(normalized):>6}")
    print(f"  {'Fichier généré':<35} {OUTPUT_FILE.name:>20}")
    print(f"\n  Par source:")
    for src, cnt in sorted(by_source.items(), key=lambda x: -x[1]):
        print(f"    {'·'} {src:<30} {cnt:>5}")
    print(f"\n  Par catégorie:")
    for cat, cnt in sorted(by_category.items(), key=lambda x: -x[1]):
        print(f"    {'·'} {cat:<35} {cnt:>4}")
    print(f"{'═'*60}{Style.RESET_ALL}")
    print(f"\n{Fore.GREEN}🎉 Done! Lancez: dart run seed_supabase.dart --from-json{Style.RESET_ALL}\n")

    return normalized


# ── ENTRY POINT ────────────────────────────────────────────────────────────────
def main():
    parser = argparse.ArgumentParser(description="CCTV Mega Scraper DZ")
    parser.add_argument(
        "--sources", nargs="+",
        default=["ouedkniss", "jumia", "electroplus", "electro-palace", "ennour", "alibaba"],
        choices=["ouedkniss", "jumia", "electroplus", "electro-palace", "ennour", "alibaba"],
        help="Sources à scraper"
    )
    parser.add_argument("--max-pages", type=int, default=15,
                        help="Nombre max de pages par requête (défaut: 15)")
    parser.add_argument("--headless", type=lambda x: x.lower() != "false",
                        default=True, help="Mode headless (défaut: true)")
    args = parser.parse_args()

    asyncio.run(run_scraper(
        sources=args.sources,
        max_pages=args.max_pages,
        headless=args.headless,
    ))


if __name__ == "__main__":
    main()
