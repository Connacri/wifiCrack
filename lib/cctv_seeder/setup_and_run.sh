#!/bin/bash
# ╔══════════════════════════════════════════════════════════════╗
# ║  CCTV Scraper DZ — Installation & Lancement                 ║
# ╚══════════════════════════════════════════════════════════════╝

set -e
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${CYAN}══════════════════════════════════════════${NC}"
echo -e "${CYAN}  🎥  CCTV Mega Scraper DZ - Setup         ${NC}"
echo -e "${CYAN}══════════════════════════════════════════${NC}\n"

# ── 1. Python deps ──────────────────────────────────────────────
echo -e "${YELLOW}[1/4] Installation des dépendances Python...${NC}"
pip install -r requirements.txt --quiet
echo -e "${GREEN}✅ Python deps OK${NC}"

# ── 2. Playwright Chromium ──────────────────────────────────────
echo -e "${YELLOW}[2/4] Installation de Playwright Chromium...${NC}"
playwright install chromium --with-deps
echo -e "${GREEN}✅ Playwright OK${NC}"

# ── 3. Dart deps ────────────────────────────────────────────────
echo -e "${YELLOW}[3/4] Installation des dépendances Dart...${NC}"
dart pub get
echo -e "${GREEN}✅ Dart deps OK${NC}"

# ── 4. Lancement ────────────────────────────────────────────────
echo -e "\n${CYAN}══════════════════════════════════════════${NC}"
echo -e "${CYAN}  Quelle action ?                           ${NC}"
echo -e "${CYAN}══════════════════════════════════════════${NC}"
echo "  1) Scraper complet (toutes sources)"
echo "  2) Scraper rapide (Jumia + Alibaba uniquement)"
echo "  3) Catalogue statique uniquement (50 produits)"
echo "  4) Seeder Supabase uniquement (fichier JSON existant)"
echo ""
read -p "Choix [1-4]: " choice

case $choice in
  1)
    echo -e "\n${YELLOW}🚀 Scraping complet...${NC}"
    python scraper_cctv_mega.py --max-pages 15 --headless true
    ;;
  2)
    echo -e "\n${YELLOW}🚀 Scraping rapide...${NC}"
    python scraper_cctv_mega.py --sources jumia alibaba --max-pages 10
    ;;
  3)
    echo -e "\n${YELLOW}📦 Catalogue statique...${NC}"
    python scraper_cctv_mega.py --sources --max-pages 0
    ;;
  4)
    echo ""
    ;;
  *)
    echo -e "${RED}Choix invalide${NC}"
    exit 1
    ;;
esac

# ── Seeder Supabase ─────────────────────────────────────────────
echo -e "\n${CYAN}══════════════════════════════════════════${NC}"
echo -e "${CYAN}  Configuration Supabase                   ${NC}"
echo -e "${CYAN}══════════════════════════════════════════${NC}"

read -p "SUPABASE_URL (https://xxx.supabase.co): " SUPA_URL
read -p "SERVICE_ROLE_KEY (eyJ...): " SUPA_KEY

echo -e "\n${YELLOW}🌱 Seeding Supabase...${NC}"

if [ -f "cctv_products_mega.json" ]; then
    # Mettre à jour seed_supabase.dart pour pointer sur le bon fichier
    sed -i "s/cctv_products.json/cctv_products_mega.json/g" seed_supabase.dart
    dart run seed_supabase.dart \
        --define=SUPABASE_URL="$SUPA_URL" \
        --define=SUPABASE_SERVICE_KEY="$SUPA_KEY" \
        --from-json
else
    dart run seed_supabase.dart \
        --define=SUPABASE_URL="$SUPA_URL" \
        --define=SUPABASE_SERVICE_KEY="$SUPA_KEY"
fi

echo -e "\n${GREEN}🎉 Terminé! Vérifiez votre table Supabase.${NC}"
