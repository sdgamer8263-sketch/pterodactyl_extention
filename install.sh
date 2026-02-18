
# =======================================
#   AUTHOR    : SDGAMER
#   TOOL      : STRICT UBUNTU RDP INSTALLER
# =======================================

# ---------- COLORS ----------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

# ---------- OS DETECTION (STRICT) ----------
detect_ubuntu() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        if [ "$ID" != "ubuntu" ]; then
            echo -e "${RED}Error: Your OS is $ID. This script is only for Ubuntu!${NC}"
            exit 1
        fi
    else
        echo -e "${RED}Error: OS detection failed. Are you sure this is Ubuntu?${NC}"
        exit 1
    fi
}

# ---------- BANNER ----------
banner() {
clear
echo -e "${CYAN}"
cat <<'EOF'
 ██████╗██████╗  ██████╗  █████╗ ███╗   ███╗███████╗██████╗ 
██╔════╝██╔══██╗██╔════╝ ██╔══██╗████╗ ████║██╔════╝██╔══██╗
╚█████╗ ██║  ██║██║  ███╗███████║██╔████╔██║█████╗  ██████╔╝
 ╚════██║██║  ██║██║   ██║██╔══██║██║╚██╔╝██║██╔══╝  ██╔══██╗
██████╔╝██████╔╝╚██████╔╝██║  ██║██║ ╚═╝ ██║███████╗██║  ██║
╚═════╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝╚═╝  ╚═╝
EOF
echo -e "${GREEN}         UBUNTU ONLY RDP INSTALLER${NC}"
echo "======================================="
echo
}

# ---------- HELPERS ----------
success_msg() {
    echo -e "\n${GREEN}✔ $1 Process Completed Successfully!${NC}"
    echo -e "${YELLOW}Press Enter to return...${NC}"
    read -r < /dev/tty
}

cd /var/www/pterodactyl && \

apt update -y && apt install git unzip -y && \

git clone https://github.com/sdgamer8263-sketch/pterodactyl_extention.git temp_ext && \

cp -r temp_ext/* . && rm -rf temp_ext && \

chown -R www-data:www-data /var/www/pterodactyl && \

chmod -R 755 /var/www/pterodactyl && \

php artisan migrate --force && php artisan optimize:clear && systemctl restart nginx

echo "Installation complete! Ab flex karo 😎"

cd /var/www/pterodactyl

y

bash <(curl -fsSL https://raw.githubusercontent.com/hopingboyz/blueprint/main/addon-installer.sh)
