/// seed_supabase.dart
/// Usage: dart run seed_supabase.dart
/// Usage JSON : dart run seed_supabase.dart --from-json
/// Usage reset: dart run seed_supabase.dart --clear

import 'dart:convert';
import 'dart:io';
import 'package:supabase/supabase.dart';

// ── CONFIG — Identique à supabase_service.dart ────────────────────────────────
// Source: lib/data/sources/supabase_service.dart
const _supabaseUrl = 'https://rfhogskyetnmtmxglmxo.supabase.co';
const _supabaseKey = 'sb_publishable_dV47DD8vh7IO9G4edWqF6Q_vg93C1Cl';

// ⚠️  Si tu vois une erreur "permission denied" sur la table products,
//     va dans Supabase Dashboard → Authentication → Policies
//     et désactive RLS sur la table products, OU ajoute une policy INSERT public.

// Batch size pour éviter les timeouts (optimisation coût API)
const _batchSize = 20;

// ── MODÈLE ────────────────────────────────────────────────────────────────────
class Product {
  final String name;
  final String? sku;
  final String? description;
  final double price;
  final double? promoPrice;
  final String? category;
  final int? stock;
  final String? imageUrl;
  final bool isActive;
  final int popularity;
  final Map<String, dynamic>? metadata;

  const Product({
    required this.name,
    this.sku,
    this.description,
    required this.price,
    this.promoPrice,
    this.category,
    this.stock,
    this.imageUrl,
    this.isActive = true,
    this.popularity = 0,
    this.metadata,
  });

  Map<String, dynamic> toSupabase() => {
        'name': name,
        'sku': sku,
        'description': description,
        'price': price,
        'promo_price': promoPrice,
        'category': category,
        'stock': stock,
        'image_url': imageUrl,
        'is_active': isActive,
        'popularity': popularity,
        'metadata': metadata != null ? jsonEncode(metadata) : null,
      };

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        name: json['name'] as String,
        sku: json['sku'] as String?,
        description: json['description'] as String?,
        price: (json['price'] as num).toDouble(),
        promoPrice: json['promo_price'] != null
            ? (json['promo_price'] as num).toDouble()
            : null,
        category: json['category'] as String?,
        stock: json['stock'] as int?,
        imageUrl: json['image_url'] as String?,
        isActive: json['is_active'] as bool? ?? true,
        popularity: json['popularity'] as int? ?? 0,
        metadata: json['metadata'] as Map<String, dynamic>?,
      );
}

// ── CATALOGUE CCTV ALGÉRIE ────────────────────────────────────────────────────
final List<Product> _cctvCatalog = [
  // ── Caméras IP ──────────────────────────────────────────────────────────────
  Product(
    name: 'Hikvision DS-2CD2143G2-I Caméra IP Dôme 4MP AcuSense',
    sku: 'HIK-2CD2143G2-001',
    description:
        'Caméra IP dôme 4MP AcuSense avec deep learning intégré. '
        'Détection humain/véhicule, vision nocturne IR 40m, IP67, IK10. '
        'H.265+, compression adaptative. Idéale entrées bâtiments.',
    price: 18500.00,
    promoPrice: 16900.00,
    category: 'Caméras IP',
    imageUrl:
        'https://www.hikvision.com/content/dam/hikvision/products/S000000001/S000000001.jpg',
    stock: 25,
    popularity: 92,
    metadata: {
      'brand': 'Hikvision',
      'resolution': '4MP',
      'ir_range': '40m',
      'compression': 'H.265+',
      'ip_rating': 'IP67',
      'vandal_proof': 'IK10',
      'smart_features': ['AcuSense', 'Détection humain', 'Détection véhicule'],
      'model': 'DS-2CD2143G2-I',
    },
  ),
  Product(
    name: 'Dahua IPC-HDW2849H-S-IL Caméra IP Smart Dual Light 8MP',
    sku: 'DAH-HDW2849H-002',
    description:
        'Caméra IP WizSense 8MP (4K) avec technologie Dual Light '
        '(IR + lumière chaude). Détection IA humain/véhicule, IP67. '
        'Parfaite pour surveillance extérieure résidentielle.',
    price: 22000.00,
    category: 'Caméras IP',
    imageUrl:
        'https://www.dahuasecurity.com/asset/upload/uploads/soft/20220119/IPC-HDW2849H-S-IL.png',
    stock: 18,
    popularity: 88,
    metadata: {
      'brand': 'Dahua',
      'resolution': '8MP/4K',
      'series': 'WizSense',
      'light_type': 'Dual Light',
      'ir_range': '30m',
      'white_light': '30m',
      'ip_rating': 'IP67',
      'model': 'IPC-HDW2849H-S-IL',
    },
  ),
  Product(
    name: 'Reolink RLC-810A Caméra IP 4K PoE Détection IA',
    sku: 'REO-RLC810A-003',
    description:
        'Caméra PoE 4K Ultra HD avec détection personne/véhicule par IA. '
        'Vision nocturne couleur StarLight, IP66, audio bidirectionnel. '
        'Compatible NVR Reolink et ONVIF standard.',
    price: 15800.00,
    promoPrice: 14200.00,
    category: 'Caméras IP',
    imageUrl:
        'https://reolink.com/wp-content/uploads/2021/01/rlc-810a-feature-1-1.jpg',
    stock: 32,
    popularity: 85,
    metadata: {
      'brand': 'Reolink',
      'resolution': '8MP/4K',
      'poe': true,
      'ai_detection': true,
      'night_color': true,
      'ip_rating': 'IP66',
      'two_way_audio': true,
      'model': 'RLC-810A',
    },
  ),
  Product(
    name: 'TP-Link Vigi C340 Caméra IP Tourelle 4MP',
    sku: 'TPL-VIGIC340-004',
    description:
        'Caméra réseau tourelle 4MP avec vision nocturne couleur. '
        'Détection de mouvement intelligente, interface Vigi app, PoE. '
        'Installation plug & play, compression H.265+.',
    price: 9800.00,
    promoPrice: 8500.00,
    category: 'Caméras IP',
    imageUrl:
        'https://static.tp-link.com/upload/product-overview/2022/202201/20220118/VIGI%20C340(4mm)_1.jpg',
    stock: 45,
    popularity: 78,
    metadata: {
      'brand': 'TP-Link',
      'series': 'VIGI',
      'resolution': '4MP',
      'poe': true,
      'night_color': true,
      'model': 'VIGI C340',
    },
  ),
  Product(
    name: 'Imou Bullet 2E IPC-F22FEP-D Caméra IP PoE 2MP',
    sku: 'IMO-F22FEP-005',
    description:
        'Caméra IP bullet extérieure 2MP avec PoE intégré. '
        'Vision nocturne IR 30m, détection humain H.265. '
        'Résistance IP67, montage facile, appli Imou Cloud.',
    price: 7200.00,
    promoPrice: 6500.00,
    category: 'Caméras IP',
    imageUrl:
        'https://imoulife.com/content/dam/imou/products/ipc-f22fep-d/01.jpg',
    stock: 50,
    popularity: 74,
    metadata: {
      'brand': 'Imou',
      'resolution': '2MP',
      'poe': true,
      'ir_range': '30m',
      'ip_rating': 'IP67',
      'model': 'IPC-F22FEP-D',
    },
  ),

  // ── Caméras Bullet ──────────────────────────────────────────────────────────
  Product(
    name: 'Hikvision DS-2CD2T47G2-L Caméra Bullet ColorVu 4MP',
    sku: 'HIK-2CD2T47G2-006',
    description:
        'Caméra bullet extérieure 4MP ColorVu - vision couleur 24/7 même sans lumière. '
        'Lumière stroboscopique & alarme sonore intégrées, IP67, portée 60m. '
        'Idéale parkings, entrepôts, périmètres.',
    price: 21500.00,
    promoPrice: 19800.00,
    category: 'Caméras Bullet',
    imageUrl:
        'https://www.hikvision.com/content/dam/hikvision/en/support/resources/datasheet/network-camera/20220121/DS-2CD2T47G2-L%20&%20DS-2CD2T47G2-LSU-SL_Datasheet_v1.0.pdf',
    stock: 15,
    popularity: 90,
    metadata: {
      'brand': 'Hikvision',
      'resolution': '4MP',
      'series': 'ColorVu',
      'color_night': true,
      'ir_range': '60m',
      'ip_rating': 'IP67',
      'strobe_alarm': true,
      'model': 'DS-2CD2T47G2-L',
    },
  ),
  Product(
    name: 'Dahua HAC-HFW1500CM-A Caméra HDCVI Bullet 5MP',
    sku: 'DAH-HFW1500CM-007',
    description:
        'Caméra HDCVI 5MP pour systèmes analogiques HD. Compatible DVR Dahua. '
        'Microphone intégré, vision nocturne IR 20m, IP67. '
        'Transition parfaite analogique → HD sans recâblage.',
    price: 7500.00,
    category: 'Caméras Bullet',
    imageUrl:
        'https://www.dahuasecurity.com/asset/upload/uploads/soft/20200901/1598953009.jpg',
    stock: 40,
    popularity: 72,
    metadata: {
      'brand': 'Dahua',
      'resolution': '5MP',
      'type': 'HDCVI',
      'built_in_mic': true,
      'ir_range': '20m',
      'ip_rating': 'IP67',
      'model': 'HAC-HFW1500CM-A',
    },
  ),
  Product(
    name: 'Annke C800 Caméra Bullet PoE 4K Ultra HD',
    sku: 'ANK-C800-008',
    description:
        'Caméra PoE 8MP 4K avec vision nocturne IR 100 pieds. '
        'Détection de mouvement intelligente, IP66, audio intégré. '
        'Compatible avec NVR ONVIF, H.265+.',
    price: 12500.00,
    promoPrice: 11000.00,
    category: 'Caméras Bullet',
    imageUrl:
        'https://annke.com/cdn/shop/products/C800_01.jpg',
    stock: 28,
    popularity: 76,
    metadata: {
      'brand': 'Annke',
      'resolution': '8MP/4K',
      'poe': true,
      'ir_range': '30m',
      'ip_rating': 'IP66',
      'model': 'C800',
    },
  ),

  // ── Caméras Dôme ────────────────────────────────────────────────────────────
  Product(
    name: 'Hikvision DS-2CD2147G2H-LI Caméra Dôme 4MP Smart Hybrid',
    sku: 'HIK-2CD2147G2H-009',
    description:
        'Caméra dôme 4MP Smart Hybrid Light - commutation auto IR/lumière visible. '
        'AcuSense détection IA, IK10 antivandalisme, IP67. '
        'Parfaite halls d\'entrée, couloirs, magasins.',
    price: 24000.00,
    promoPrice: 21500.00,
    category: 'Caméras Dôme',
    imageUrl:
        'https://www.hikvision.com/content/dam/hikvision/en/support/regional-materials/algeria/products-and-solutions/network-camera.jpg',
    stock: 20,
    popularity: 86,
    metadata: {
      'brand': 'Hikvision',
      'resolution': '4MP',
      'series': 'AcuSense',
      'hybrid_light': true,
      'vandal_proof': 'IK10',
      'ip_rating': 'IP67',
      'model': 'DS-2CD2147G2H-LI',
    },
  ),
  Product(
    name: 'Dahua IPC-HDW3849H-AS-PV Caméra Dôme Full-Color 8MP',
    sku: 'DAH-HDW3849H-010',
    description:
        'Caméra dôme Smart Dual Light 8MP avec lumière d\'ambiance intégrée. '
        'Détection WizSense IA, alarme sonore/lumineuse active. '
        'IP67, IK10, montage mural ou plafond.',
    price: 31000.00,
    promoPrice: 28000.00,
    category: 'Caméras Dôme',
    imageUrl:
        'https://www.dahuasecurity.com/asset/upload/uploads/soft/20220401/IPC-HDW3849H-AS-PV.png',
    stock: 16,
    popularity: 84,
    metadata: {
      'brand': 'Dahua',
      'resolution': '8MP/4K',
      'full_color': true,
      'active_deterrence': true,
      'vandal_proof': 'IK10',
      'ip_rating': 'IP67',
      'model': 'IPC-HDW3849H-AS-PV',
    },
  ),

  // ── DVR / Enregistreurs ──────────────────────────────────────────────────────
  Product(
    name: 'Hikvision DS-7208HUHI-K2 DVR 8 Voies 5MP TurboHD',
    sku: 'HIK-7208HUHI-011',
    description:
        'DVR TurboHD 8 canaux 5MP - compatible HDTVI/HDCVI/AHD/CVBS/IP. '
        'H.265 Pro+, 2 HDD jusqu\'à 10TB, Deep Learning analytics. '
        'Sortie HDMI 4K, interface web & mobile. Alimentation 100-240V.',
    price: 35000.00,
    promoPrice: 31500.00,
    category: 'DVR/Enregistreurs',
    imageUrl:
        'https://www.hikvision.com/content/dam/hikvision/en/support/regional-materials/algeria/products-and-solutions/turbo-hd-dvr.jpg',
    stock: 12,
    popularity: 94,
    metadata: {
      'brand': 'Hikvision',
      'channels': 8,
      'max_resolution': '5MP',
      'hdd_slots': 2,
      'max_hdd_tb': 10,
      'compression': 'H.265 Pro+',
      'ai_analytics': true,
      'hdmi_4k': true,
      'model': 'DS-7208HUHI-K2',
    },
  ),
  Product(
    name: 'Dahua XVR5116HS-I3 DVR 16 Voies WizSense',
    sku: 'DAH-XVR5116HS-012',
    description:
        'DVR penta-brid 16 canaux WizSense avec IA intégrée. '
        'Jusqu\'à 5MP lite, détection humain/véhicule H.265+. '
        '1 slot HDD, accès mobile DMSS, interface intuitive.',
    price: 42000.00,
    category: 'DVR/Enregistreurs',
    imageUrl:
        'https://www.dahuasecurity.com/asset/upload/uploads/soft/20210526/XVR5116HS-I3.png',
    stock: 8,
    popularity: 89,
    metadata: {
      'brand': 'Dahua',
      'channels': 16,
      'series': 'WizSense',
      'hdd_slots': 1,
      'ai_detection': true,
      'compression': 'H.265+',
      'mobile_app': 'DMSS',
      'model': 'XVR5116HS-I3',
    },
  ),
  Product(
    name: 'Hikvision DS-7104HQHI-K1 DVR 4 Voies 3MP Compact',
    sku: 'HIK-7104HQHI-013',
    description:
        'DVR 4 canaux 3MP format compact pour petites installations. '
        'Compatible HDTVI/AHD/CVI/CVBS/IP, H.265+. '
        '1 HDD jusqu\'à 8TB, sortie VGA+HDMI, application mobile.',
    price: 16500.00,
    promoPrice: 14800.00,
    category: 'DVR/Enregistreurs',
    imageUrl:
        'https://www.hikvision.com/content/dam/hikvision/products/S000000001/S000000001.jpg',
    stock: 22,
    popularity: 80,
    metadata: {
      'brand': 'Hikvision',
      'channels': 4,
      'max_resolution': '3MP',
      'hdd_slots': 1,
      'max_hdd_tb': 8,
      'compression': 'H.265+',
      'model': 'DS-7104HQHI-K1',
    },
  ),

  // ── NVR / Enregistreurs IP ───────────────────────────────────────────────────
  Product(
    name: 'Hikvision DS-7608NI-I2/8P NVR 8 Voies PoE 4K',
    sku: 'HIK-7608NI-I2-014',
    description:
        'NVR 8 voies avec switch PoE intégré 8 ports. '
        'Résolution max 12MP, H.265+, 2 HDD jusqu\'à 12TB. '
        'Décodage 4K HDMI, détection intelligente Deep Learning.',
    price: 52000.00,
    promoPrice: 47500.00,
    category: 'NVR/Enregistreurs IP',
    imageUrl:
        'https://www.hikvision.com/content/dam/hikvision/en/support/regional-materials/algeria/products-and-solutions/network-video-recorder.jpg',
    stock: 10,
    popularity: 91,
    metadata: {
      'brand': 'Hikvision',
      'channels': 8,
      'poe_ports': 8,
      'max_resolution': '12MP',
      'hdd_slots': 2,
      'max_hdd_tb': 12,
      'compression': 'H.265+',
      'hdmi_4k': true,
      'model': 'DS-7608NI-I2/8P',
    },
  ),
  Product(
    name: 'Dahua NVR4104HS-P-4KS3 NVR 4 Voies PoE WizSense',
    sku: 'DAH-NVR4104HS-015',
    description:
        'NVR compact 4 voies WizSense avec 4 ports PoE intégrés. '
        'Résolution 4K/8MP, H.265+, 1 HDD jusqu\'à 8TB. '
        'Détection IA humain/véhicule, accès DMSS, SMD Plus.',
    price: 28500.00,
    promoPrice: 26000.00,
    category: 'NVR/Enregistreurs IP',
    imageUrl:
        'https://www.dahuasecurity.com/asset/upload/uploads/soft/20220301/NVR4104HS-P-4KS3.png',
    stock: 14,
    popularity: 83,
    metadata: {
      'brand': 'Dahua',
      'channels': 4,
      'poe_ports': 4,
      'max_resolution': '8MP/4K',
      'hdd_slots': 1,
      'max_hdd_tb': 8,
      'ai_series': 'WizSense',
      'model': 'NVR4104HS-P-4KS3',
    },
  ),
  Product(
    name: 'Reolink RLN8-410 NVR 8 Voies PoE sans disque',
    sku: 'REO-RLN8410-016',
    description:
        'NVR 8 canaux PoE compatible caméras Reolink et ONVIF. '
        '4K Ultra HD, 2 slots HDD jusqu\'à 12TB, H.265. '
        'Interface Reolink Client PC/Mac/Mobile, accès cloud.',
    price: 21000.00,
    category: 'NVR/Enregistreurs IP',
    imageUrl:
        'https://reolink.com/wp-content/uploads/2019/10/rln8-410-feature-1.jpg',
    stock: 18,
    popularity: 77,
    metadata: {
      'brand': 'Reolink',
      'channels': 8,
      'poe_ports': 8,
      'hdd_slots': 2,
      'max_hdd_tb': 12,
      'model': 'RLN8-410',
    },
  ),

  // ── Kits Complets ─────────────────────────────────────────────────────────────
  Product(
    name: 'Kit Surveillance Hikvision 4 Caméras 4MP + DVR 8CH',
    sku: 'KIT-HIK-4CAM-017',
    description:
        'Kit complet prêt à installer : 4x caméras dôme ColorVu 4MP + '
        'DVR 8 canaux H.265+ + câbles 20m + alimentations. '
        'Vision couleur nuit, couverture 360°. '
        'Idéal maisons, petits commerces.',
    price: 95000.00,
    promoPrice: 85000.00,
    category: 'Kits Complets',
    imageUrl:
        'https://www.hikvision.com/content/dam/hikvision/en/support/regional-materials/algeria/products-and-solutions/solutions.jpg',
    stock: 6,
    popularity: 96,
    metadata: {
      'brand': 'Hikvision',
      'cameras': 4,
      'dvr_channels': 8,
      'camera_resolution': '4MP',
      'includes_cables': true,
      'includes_psu': true,
      'kit_type': 'analogique_hd',
    },
  ),
  Product(
    name: 'Kit IP Dahua WizSense 8 Caméras 4K + NVR 8CH PoE',
    sku: 'KIT-DAH-8CAM-018',
    description:
        'Kit professionnel IP 4K : 8x caméras bullet WizSense 8MP + '
        'NVR PoE 8 canaux + HDD 2TB + câbles Cat6. '
        'Détection IA incluse, installation plug & play via PoE.',
    price: 185000.00,
    promoPrice: 168000.00,
    category: 'Kits Complets',
    imageUrl:
        'https://www.dahuasecurity.com/asset/upload/uploads/soft/20211201/wiz-sense-kit.jpg',
    stock: 3,
    popularity: 95,
    metadata: {
      'brand': 'Dahua',
      'cameras': 8,
      'nvr_channels': 8,
      'camera_resolution': '8MP/4K',
      'includes_hdd_tb': 2,
      'includes_cables': true,
      'poe_system': true,
      'kit_type': 'ip_4k',
    },
  ),
  Product(
    name: 'Kit Débutant 2 Caméras Imou IP + NVR 4CH Wi-Fi',
    sku: 'KIT-IMO-2CAM-019',
    description:
        'Kit entrée de gamme Wi-Fi : 2x caméras Imou Bullet 2MP + NVR 4 canaux. '
        'Application mobile, vision nocturne IR, détection mouvement. '
        'Idéal appartement, petit bureau, installation sans câble réseau.',
    price: 32000.00,
    promoPrice: 28500.00,
    category: 'Kits Complets',
    imageUrl:
        'https://imoulife.com/content/dam/imou/products/kit/kit-wf.jpg',
    stock: 20,
    popularity: 82,
    metadata: {
      'brand': 'Imou',
      'cameras': 2,
      'nvr_channels': 4,
      'camera_resolution': '2MP',
      'wifi': true,
      'kit_type': 'wifi_entry',
    },
  ),

  // ── Câbles & Accessoires ───────────────────────────────────────────────────
  Product(
    name: 'Câble Coaxial RG59+Alimentation 100m Bobine CCTV',
    sku: 'ACC-RG59-100M-020',
    description:
        'Bobine 100m câble siamois RG59 + 2 fils alimentation 0.75mm². '
        'Blindage aluminium double couche, âme cuivre 0.81mm. '
        'Compatible toutes caméras analogiques HD (HDCVI/HDTVI/AHD).',
    price: 4800.00,
    category: 'Câbles & Accessoires',
    imageUrl:
        'https://m.media-amazon.com/images/I/71bBL8bU+mL._AC_SL1500_.jpg',
    stock: 60,
    popularity: 65,
    metadata: {
      'cable_type': 'RG59+Power',
      'length_m': 100,
      'core': '0.81mm cuivre',
      'shielding': 'double aluminium',
      'compatible': ['HDCVI', 'HDTVI', 'AHD', 'CVBS'],
    },
  ),
  Product(
    name: 'Câble FTP Cat6 305m Bobine pour Caméras IP PoE',
    sku: 'ACC-CAT6-305M-021',
    description:
        'Bobine 305m câble réseau FTP Cat6 pour caméras IP PoE. '
        'Conducteurs cuivre pur 0.57mm, paire torsadée blindée. '
        'Résistance jusqu\'à 100m par caméra PoE, débit 1Gbps.',
    price: 8500.00,
    promoPrice: 7800.00,
    category: 'Câbles & Accessoires',
    imageUrl:
        'https://m.media-amazon.com/images/I/71X1u+KJKYL._AC_SL1500_.jpg',
    stock: 35,
    popularity: 70,
    metadata: {
      'cable_type': 'FTP Cat6',
      'length_m': 305,
      'conductor': 'cuivre pur',
      'gauge': '0.57mm',
      'speed': '1Gbps',
      'poe_compatible': true,
    },
  ),
  Product(
    name: 'Switch PoE+ 8 Ports Gigabit + 2 Uplink pour IP Camera',
    sku: 'ACC-SW8POE-022',
    description:
        'Switch non managé PoE+ 8 ports 10/100/1000Mbps + 2 ports uplink SFP. '
        'Budget PoE 150W, IEEE 802.3af/at. Compatible toutes caméras PoE. '
        'Watchdog automatique, boîtier métal.',
    price: 9500.00,
    promoPrice: 8800.00,
    category: 'Câbles & Accessoires',
    imageUrl:
        'https://m.media-amazon.com/images/I/61b3V6DY3hL._AC_SL1500_.jpg',
    stock: 30,
    popularity: 75,
    metadata: {
      'type': 'Switch PoE+',
      'poe_ports': 8,
      'uplink_ports': 2,
      'poe_budget_w': 150,
      'standard': 'IEEE 802.3af/at',
      'watchdog': true,
    },
  ),

  // ── Alimentations ─────────────────────────────────────────────────────────
  Product(
    name: 'Alimentation Switching 12V 10A Boîtier Métal 8 Sorties',
    sku: 'PWR-12V10A-023',
    description:
        'Alimentation à découpage 12V DC / 10A pour centrales CCTV. '
        '8 sorties fusibles indépendantes, boîtier métal IP20. '
        'Protection court-circuit/surcharge/surtension. 100-240V AC.',
    price: 3200.00,
    category: 'Alimentations',
    imageUrl:
        'https://m.media-amazon.com/images/I/61PCVHygHuL._AC_SL1500_.jpg',
    stock: 55,
    popularity: 60,
    metadata: {
      'voltage': '12V DC',
      'current_a': 10,
      'outputs': 8,
      'protection': ['court-circuit', 'surcharge', 'surtension'],
      'input': '100-240V AC',
      'ip_rating': 'IP20',
    },
  ),
  Product(
    name: 'Alimentation 12V 30A Grande Capacité pour DVR/NVR',
    sku: 'PWR-12V30A-024',
    description:
        'Alimentation professionnelle 12V/30A pour centrales multi-caméras. '
        '16 sorties individuelles, ventilateur intégré, boîtier rack. '
        'Idéale installations de 8 à 16 caméras.',
    price: 7800.00,
    promoPrice: 7000.00,
    category: 'Alimentations',
    imageUrl:
        'https://m.media-amazon.com/images/I/71Ot5D7f7RL._AC_SL1500_.jpg',
    stock: 20,
    popularity: 55,
    metadata: {
      'voltage': '12V DC',
      'current_a': 30,
      'outputs': 16,
      'cooling': 'ventilateur',
      'form_factor': 'rack',
    },
  ),

  // ── Stockage ──────────────────────────────────────────────────────────────
  Product(
    name: 'Seagate SkyHawk 2TB HDD Surveillance 24/7',
    sku: 'HDD-SKY-2TB-025',
    description:
        'Disque dur dédié surveillance continue 24/7. '
        'Optimisé flux multi-caméras, jusqu\'à 64 caméras HD simultanées. '
        'MTBF 1 million d\'heures, garantie 3 ans. Compatible DVR/NVR.',
    price: 16500.00,
    promoPrice: 15200.00,
    category: 'Stockage',
    imageUrl:
        'https://www.seagate.com/content/dam/seagate/migrated-assets/www-content/product-content/skyhawk/en-us/docs/skyhawk-2tb-desktop.png',
    stock: 28,
    popularity: 88,
    metadata: {
      'brand': 'Seagate',
      'series': 'SkyHawk',
      'capacity_tb': 2,
      'rpm': 5900,
      'cache_mb': 256,
      'workload_tb_year': 180,
      'concurrent_cameras': 64,
      'warranty_years': 3,
    },
  ),
  Product(
    name: 'WD Purple 4TB HDD NAS/DVR Surveillance',
    sku: 'HDD-WDP-4TB-026',
    description:
        'Disque WD Purple 4TB conçu pour enregistreurs CCTV. '
        'AllFrame AI technology, charge de travail 180TB/an. '
        'Support simultané 8 flux 4K, firmware optimisé surveillance.',
    price: 28000.00,
    category: 'Stockage',
    imageUrl:
        'https://www.westerndigital.com/content/dam/store/en-us/assets/products/internal-storage/wd-purple/gallery/wd-purple-sata-hdd-western-digital.png.thumb.319.319.png',
    stock: 20,
    popularity: 82,
    metadata: {
      'brand': 'WD',
      'series': 'Purple',
      'capacity_tb': 4,
      'rpm': 5400,
      'cache_mb': 256,
      'workload_tb_year': 180,
      'concurrent_4k_streams': 8,
    },
  ),
  Product(
    name: 'Seagate SkyHawk 4TB HDD Surveillance IA',
    sku: 'HDD-SKY-4TB-027',
    description:
        'Version 4TB du SkyHawk pour DVR/NVR haute capacité. '
        'Jusqu\'à 16 caméras HD simultanées en écriture, '
        '256Mo cache, firmware ImagePerfect Zero.',
    price: 29500.00,
    promoPrice: 27000.00,
    category: 'Stockage',
    imageUrl:
        'https://www.seagate.com/content/dam/seagate/migrated-assets/www-content/product-content/skyhawk/en-us/docs/skyhawk-4tb-desktop.png',
    stock: 15,
    popularity: 79,
    metadata: {
      'brand': 'Seagate',
      'series': 'SkyHawk',
      'capacity_tb': 4,
      'rpm': 5900,
      'cache_mb': 256,
      'firmware': 'ImagePerfect Zero',
    },
  ),

  // ── PTZ ───────────────────────────────────────────────────────────────────
  Product(
    name: 'Hikvision DS-2DE4A425IWG-E PTZ IP 4MP 25x Zoom',
    sku: 'HIK-PTZ4425-028',
    description:
        'Caméra PTZ IP 4MP avec zoom optique 25x et zoom numérique 16x. '
        'IR 100m, AcuSense, suivi automatique cible, IP66. '
        'Idéale grands espaces : parkings, entrepôts, stades.',
    price: 145000.00,
    promoPrice: 132000.00,
    category: 'Caméras PTZ',
    imageUrl:
        'https://www.hikvision.com/content/dam/hikvision/en/support/regional-materials/algeria/products-and-solutions/ptz.jpg',
    stock: 4,
    popularity: 78,
    metadata: {
      'brand': 'Hikvision',
      'resolution': '4MP',
      'optical_zoom': 25,
      'digital_zoom': 16,
      'ir_range': '100m',
      'auto_tracking': true,
      'ip_rating': 'IP66',
      'model': 'DS-2DE4A425IWG-E',
    },
  ),
  Product(
    name: 'Dahua SD49425XB-HNR PTZ 4MP 25x AI Wizsense',
    sku: 'DAH-SD49425XB-029',
    description:
        'Caméra PTZ réseau 4MP 25x zoom optique WizSense. '
        'Suivi automatique avancé, détection IA, IR 100m, IP66. '
        'Idéale surveillance périmétrique professionnelle.',
    price: 138000.00,
    promoPrice: 125000.00,
    category: 'Caméras PTZ',
    imageUrl:
        'https://www.dahuasecurity.com/asset/upload/uploads/soft/20220101/SD49425XB-HNR.png',
    stock: 3,
    popularity: 76,
    metadata: {
      'brand': 'Dahua',
      'resolution': '4MP',
      'optical_zoom': 25,
      'series': 'WizSense',
      'auto_tracking': true,
      'ir_range': '100m',
      'ip_rating': 'IP66',
      'model': 'SD49425XB-HNR',
    },
  ),
];

// ── SEEDER ────────────────────────────────────────────────────────────────────
class SupabaseSeeder {
  final SupabaseClient _client;
  int _inserted = 0;
  int _updated = 0;
  int _errors = 0;

  SupabaseSeeder(this._client);

  Future<void> seed({bool clearFirst = false}) async {
    print('\n╔══════════════════════════════════════════════╗');
    print('║   🎥  CCTV Supabase Seeder - Algérie DZD    ║');
    print('╚══════════════════════════════════════════════╝\n');

    // Optionnel : vider la table avant
    if (clearFirst) {
      print('🗑️  Suppression des données existantes...');
      await _client.from('products').delete().neq('id', '00000000-0000-0000-0000-000000000000');
      print('✅ Table vidée\n');
    }

    final products = _cctvCatalog;
    final batches = _splitBatches(products, _batchSize);

    print('📦 ${products.length} produits à insérer en ${batches.length} batch(es)');
    print('─' * 50);

    for (var i = 0; i < batches.length; i++) {
      final batch = batches[i];
      print('\n📤 Batch ${i + 1}/${batches.length} (${batch.length} produits)...');
      await _insertBatch(batch, i + 1);
      // Throttle pour économiser les ressources Supabase
      if (i < batches.length - 1) await Future.delayed(const Duration(milliseconds: 300));
    }

    _printSummary(products.length);
  }

  Future<void> _insertBatch(List<Product> batch, int batchNum) async {
    final rows = batch.map((p) => p.toSupabase()).toList();

    try {
      await _client.from('products').upsert(
            rows,
            onConflict: 'sku', // Upsert sur SKU unique
          );

      _inserted += batch.length;
      for (final p in batch) {
        print('  ✓ [${p.sku}] ${p.name} — ${_formatDzd(p.price)}');
      }
    } on PostgrestException catch (e) {
      _errors += batch.length;
      print('  ❌ Erreur batch $batchNum: ${e.message}');
      print('     Code: ${e.code} | Détails: ${e.details}');

      // Retry individuel en cas d'erreur de batch
      print('  🔄 Tentative insertion individuelle...');
      for (final product in batch) {
        await _insertSingle(product);
      }
    }
  }

  Future<void> _insertSingle(Product product) async {
    try {
      await _client.from('products').upsert(
            product.toSupabase(),
            onConflict: 'sku',
          );
      _inserted++;
      _errors = (_errors > 0) ? _errors - 1 : 0;
      print('    ✓ Récupéré: ${product.sku}');
    } on PostgrestException catch (e) {
      print('    ✗ Échec définitif [${product.sku}]: ${e.message}');
    }
  }

  // ── Import depuis fichier JSON (résultat du scraper Python) ─────────────────
  Future<void> seedFromJson(String filePath) async {
    print('\n📂 Import depuis: $filePath');
    final file = File(filePath);
    if (!await file.exists()) {
      print('❌ Fichier introuvable: $filePath');
      return;
    }

    final content = await file.readAsString();
    final List<dynamic> jsonList = jsonDecode(content);
    final products = jsonList
        .map((j) => Product.fromJson(j as Map<String, dynamic>))
        .toList();

    print('📦 ${products.length} produits chargés depuis JSON');
    final batches = _splitBatches(products, _batchSize);

    for (var i = 0; i < batches.length; i++) {
      await _insertBatch(batches[i], i + 1);
      if (i < batches.length - 1) await Future.delayed(const Duration(milliseconds: 300));
    }

    _printSummary(products.length);
  }

  List<List<T>> _splitBatches<T>(List<T> list, int size) {
    final batches = <List<T>>[];
    for (var i = 0; i < list.length; i += size) {
      batches.add(list.sublist(i, i + size > list.length ? list.length : i + size));
    }
    return batches;
  }

  String _formatDzd(double price) {
    final parts = price.toStringAsFixed(0).split('');
    final result = StringBuffer();
    for (var i = 0; i < parts.length; i++) {
      if (i > 0 && (parts.length - i) % 3 == 0) result.write(' ');
      result.write(parts[i]);
    }
    return '${result.toString()} DA';
  }

  void _printSummary(int total) {
    print('\n╔══════════════════════════════════════════════╗');
    print('║               📊 RÉSUMÉ SEEDER               ║');
    print('╠══════════════════════════════════════════════╣');
    print('║  Total produits    : $total'.padRight(46) + '║');
    print('║  ✅ Insérés/MAJ    : $_inserted'.padRight(46) + '║');
    print('║  ❌ Erreurs        : $_errors'.padRight(46) + '║');
    print('╚══════════════════════════════════════════════╝\n');

    if (_errors == 0) {
      print('🎉 Seeding terminé avec succès!');
      print('👉 Vérifiez sur: https://supabase.com/dashboard');
    } else {
      print('⚠️  Seeding terminé avec $_errors erreur(s). Vérifiez les logs.');
    }
  }
}

// ── MAIN ──────────────────────────────────────────────────────────────────────
Future<void> main(List<String> args) async {
  // Client Supabase — même config que dans supabase_service.dart
  final client = SupabaseClient(_supabaseUrl, _supabaseKey);
  final seeder = SupabaseSeeder(client);

  print('\n🔗 Connexion à: $_supabaseUrl');

  if (args.contains('--from-json')) {
    // ── Priorité 1 : fichier du mega scraper ──────────────────────────────────
    const megaFile  = 'cctv_products_mega.json';  // scraper_cctv_mega.py
    const basicFile = 'cctv_products.json';        // scraper_cctv_dz.py (ancien)

    if (await File(megaFile).exists()) {
      await seeder.seedFromJson(megaFile);
    } else if (await File(basicFile).exists()) {
      await seeder.seedFromJson(basicFile);
    } else {
      print('❌ Aucun fichier JSON trouvé ($megaFile ou $basicFile).');
      print('   Lance d\'abord: python scraper_cctv_mega.py');
      exit(1);
    }
  } else {
    // ── Priorité 2 : catalogue intégré (29 produits, toujours dispo) ──────────
    await seeder.seed(clearFirst: args.contains('--clear'));
  }

  exit(0);
}
