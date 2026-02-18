#!/bin/bash

# =============================================================
#   AUTHOR    : SDGAMER
#   TOOL      : PTERODACTYL BLUEPRINT EXTENSION INSTALLER
# =============================================================

# ---------- COLORS & STYLE ----------
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
PURPLE='\033[1;35m'
NC='\033[0m' # No Color

# ---------- BANNER ----------
banner() {
    clear
    echo -e "${CYAN}┌──────────────────────────────────────────────────────────┐${NC}"
    echo -e "${CYAN}│${PURPLE}  ██████╗██████╗  ██████╗  █████╗ ███╗   ███╗███████╗██████╗ ${CYAN}│${NC}"
    echo -e "${CYAN}│${PURPLE} ██╔════╝██╔══██╗██╔════╝ ██╔══██╗████╗ ████║██╔════╝██╔══██╗${CYAN}│${NC}"
    echo -e "${CYAN}│${PURPLE} ╚█████╗ ██║  ██║██║  ███╗███████║██╔████╔██║█████╗  ██████╔╝${CYAN}│${NC}"
    echo -e "${CYAN}│${PURPLE}  ╚════██║██║  ██║██║   ██║██╔══██║██║╚██╔╝██║██╔══╝  ██╔══██╗${CYAN}│${NC}"
    echo -e "${CYAN}│${PURPLE} ██████╔╝██████╔╝╚██████╔╝██║  ██║██║ ╚═╝ ██║███████╗██║  ██║${CYAN}│${NC}"
    echo -e "${CYAN}│${PURPLE} ╚═════╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝╚═╝  ╚═╝${CYAN}│${NC}"
    echo -e "${CYAN}└──────────────────────────────────────────────────────────┘${NC}"
    echo -e "       ${GREEN}⚡  PTERODACTYL BLUEPRINT EXTENTION INSTALLER ⚡${NC}"
    echo -e "           ${YELLOW}Created with ❤️ by SDGAMER${NC}"
    echo -e "${CYAN}------------------------------------------------------------${NC}"
    echo
}

# ---------- OS DETECTION ----------
detect_ubuntu() {
    echo -e "${CYAN}[1/4]${NC} Checking System Compatibility..."
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        if [ "$ID" != "ubuntu" ]; then
            echo -e "${RED}❌ Error: Your OS is $ID. This script requires Ubuntu!${NC}"
            exit 1
        fi
    else
        echo -e "${RED}❌ Error: OS detection failed.${NC}"
        exit 1
    fi
    echo -e "${GREEN}✔ Ubuntu Detected!${NC}\n"
}

# ---------- MAIN EXECUTION ----------
banner
detect_ubuntu

# 1. Update and Install Dependencies
echo -e "${CYAN}[2/4]${NC} Installing Dependencies..."
apt update -y && apt install git unzip curl -y

# 2. Extension Installation
echo -e "${CYAN}[3/4]${NC} Cloning and Installing Extension..."
cd /var/www/pterodactyl || { echo -e "${RED}Directory not found!${NC}"; exit 1; }

git clone https://github.com/sdgamer8263-sketch/pterodactyl_extention.git temp_ext
cp -r temp_ext/* .
rm -rf temp_ext

# Permissions
chown -R www-data:www-data /var/www/pterodactyl
chmod -R 755 /var/www/pterodactyl

# Optimization
echo -e "${CYAN}[4/4]${NC} Finalizing Panel Configuration..."
php artisan migrate --force
php artisan optimize:clear
systemctl restart nginx

# 3. Blueprint Addon Installer (Optional/External)
echo -e "${YELLOW}Do you want to run the Blueprint Addon Installer? (y/n)${NC}"
read -r response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    bash <(curl -fsSL https://raw.githubusercontent.com/hopingboyz/blueprint/main/addon-installer.sh)
fi

echo -e "\n${GREEN}🚀 Installation complete! Ab flex karo 😎${NC}"
