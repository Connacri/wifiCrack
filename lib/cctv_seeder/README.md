# 🎥 CCTV Seeder - Algérie (DZD)

Scraper + Seeder pour populer la table `products` Supabase avec du matériel CCTV
et leurs prix en Dinar Algérien (DZD).

---

## 📁 Structure

```
.
├── scraper_cctv_dz.py    # Scraper Python (Ouedkniss + Jumia DZ + catalogue statique)
├── seed_supabase.dart     # Script Dart pour injecter dans Supabase
├── pubspec.yaml           # Dépendances Dart
└── cctv_products.json     # Généré par le scraper (optionnel)
```

---

## 🐍 Étape 1 — Scraping Python

### Installation
```bash
pip install requests beautifulsoup4 lxml
```

### Lancement
```bash
python scraper_cctv_dz.py
```

Génère `cctv_products.json` avec :
- **Catalogue statique** (20 produits garantis, prix terrain DZD)
- **Ouedkniss** — annonces caméras surveillance
- **Jumia DZ** — produits CCTV avec prix

---

## 🎯 Étape 2 — Seeder Dart → Supabase

### Installation
```bash
dart pub get
```

### Configuration (2 méthodes)

#### Méthode A — Variables d'environnement shell
```bash
export SUPABASE_URL="https://VOTRE_REF.supabase.co"
export SUPABASE_SERVICE_KEY="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
```

#### Méthode B — Define au moment de la commande
```bash
dart run seed_supabase.dart \
  --define=SUPABASE_URL=https://VOTRE_REF.supabase.co \
  --define=SUPABASE_SERVICE_KEY=eyJ...
```

### Lancement

```bash
# Mode catalogue intégré (recommandé premier lancement)
dart run seed_supabase.dart

# Vider la table puis re-insérer
dart run seed_supabase.dart --clear

# Importer depuis le JSON du scraper Python
dart run seed_supabase.dart --from-json
```

---

## 📦 Catalogue intégré (29 produits)

| Catégorie              | Produits | Prix min DZD | Prix max DZD |
|------------------------|----------|--------------|--------------|
| Caméras IP             | 5        | 7 200        | 22 000       |
| Caméras Bullet         | 3        | 7 500        | 21 500       |
| Caméras Dôme           | 2        | 24 000       | 31 000       |
| DVR/Enregistreurs      | 3        | 16 500       | 42 000       |
| NVR/Enregistreurs IP   | 3        | 21 000       | 52 000       |
| Kits Complets          | 3        | 32 000       | 185 000      |
| Câbles & Accessoires   | 3        | 4 800        | 9 500        |
| Alimentations          | 2        | 3 200        | 7 800        |
| Stockage               | 3        | 16 500       | 29 500       |
| Caméras PTZ            | 2        | 138 000      | 145 000      |

**Marques couvertes** : Hikvision · Dahua · Reolink · TP-Link Vigi · Imou · Annke · Seagate · WD

---

## ⚙️ Comportement du seeder

- **Upsert sur `sku`** → pas de doublons si relancé
- **Batch de 20** → optimise les calls API Supabase
- **Throttle 300ms** entre batches → évite rate limiting
- **Retry individuel** si un batch échoue
- **Métadonnées JSONB** complètes (brand, specs techniques, features)

---

## 🔑 Récupérer la Service Role Key

1. Dashboard Supabase → `Settings` → `API`
2. Copier `service_role` (secret) — **jamais** `anon` pour le seeding
3. Ne jamais committer cette clé dans git

---

## 💡 Notes sources de prix DZD

Les prix sont issus de relevés terrain (Mars 2025) :
- Marché BAB EZZOUAR (Alger)
- RIADH EL FETH (Alger)  
- Zone Industrielle ORAN
- CONSTANTINE Centre IT

Marge distributeur algérien appliquée : +15 à +35% sur prix import.
