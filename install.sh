#!/bin/bash

# --- COLORS ---
# Terminal e full black look anar jonno Bold White (W) ar Background color set kora hoyeche
W='\033[1;37m'
B='\033[0;30m'
BG_BLACK='\033[40m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

clear

# --- VIDEO STYLE BLACK BANNER ---
echo -e "${W}${BG_BLACK}# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ #${NC}"
echo -e "${W}${BG_BLACK}#                                                       #${NC}"
echo -e "${W}${BG_BLACK}#   ███████╗██████╗  ██████╗  █████╗ ███╗   ███╗███████╗██████╗  #${NC}"
echo -e "${W}${BG_BLACK}#   ██╔════╝██╔══██╗██╔════╝ ██╔══██╗████╗ ████║██╔════╝██╔══██╗ #${NC}"
echo -e "${W}${BG_BLACK}#   ███████╗██║  ██║██║  ███╗███████║██╔████╔██║█████╗  ██████╔╝ #${NC}"
echo -e "${W}${BG_BLACK}#   ╚════██║██║  ██║██║   ██║██╔══██║██║╚██╔╝██║██╔══╝  ██╔══██╗ #${NC}"
echo -e "${W}${BG_BLACK}#   ███████║██████╔╝╚██████╔╝██║  ██║██║ ╚═╝ ██║███████╗██║  ██║ #${NC}"
echo -e "${W}${BG_BLACK}#   ╚══════╝╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝╚═╝  ╚═╝ #${NC}"
echo -e "${W}${BG_BLACK}#                                                       #${NC}"
echo -e "${W}${BG_BLACK}# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ #${NC}"
echo -e "${W}${BG_BLACK}#                   >> SKA HOSTING <<                   #${NC}"
echo -e "${W}${BG_BLACK}#           >> PTERODACTYL EXTRA BLUEPRINT <<           #${NC}"
echo -e "${W}${BG_BLACK}# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ #${NC}"

echo ""
echo -e "${W}[*] PROGRESS: LOADING MODULES...${NC}"

# --- INSTALLATION START ---
cd /var/www/pterodactyl && \
apt update -y && apt install git unzip -y && \

echo -e "${CYAN}[SUCCESS] SYSTEM UPDATED!${NC}"

# Clone & Copy Extension
git clone https://github.com/sdgamer8263-sketch/pterodactyl_extention.git temp_ext && \
cp -r temp_ext/* . && rm -rf temp_ext && \

# Web UI Banner Injection (Black Theme)
sed -i '/<body/a \
<div style="text-align: center; padding: 25px; background: #000000; color: #ffffff; border-bottom: 4px solid #ffffff; font-family: monospace;"> \
    <h1 style="margin:0; font-size: 3.5em; letter-spacing: 5px;">SDGAMER</h1> \
    <h2 style="margin:10px 0; letter-spacing: 2px;">SKA HOSTING</h2> \
    <p style="margin:0; color: #888;">PTERODACTYL EXTRA BLUEPRINT SYSTEM</p> \
</div>' resources/views/templates/wrapper.blade.php && \

# Permissions
chown -R www-data:www-data /var/www/pterodactyl && \
chmod -R 755 /var/www/pterodactyl && \
php artisan migrate --force && php artisan optimize:clear && \

# Blueprint Auto-Install
echo -e "${W}[*] HELPERS: STARTING BLUEPRINT...${NC}"
yes | bash <(curl -fsSL https://raw.githubusercontent.com/hopingboyz/blueprint/main/addon-installer.sh) && \

# Restart Services
systemctl restart nginx && systemctl restart php-fpm

echo ""
echo -e "${W}${BG_BLACK}# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ #${NC}"
echo -e "${W}${BG_BLACK}#             INSTALLATION COMPLETE (NO SFTP)           #${NC}"
echo -e "${W}${BG_BLACK}#               AB UNLIMITED FLEX KARO 😎               #${NC}"
echo -e "${W}${BG_BLACK}# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ #${NC}"
