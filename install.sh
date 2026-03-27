# ======================================================================
#   AUTHOR    : SDGAMER
#   TOOL      : PTERODACTYL EXTRA BLUEPRINT EXTENTIONS INSTALLER
# ======================================================================

# ---------- COLORS & STYLES ----------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
WHITE='\033[1;37m'
BOLD='\033[1m'
NC='\033[0m'

# ---------- ICONS ----------
TICK="${GREEN}[✔]${NC}"
CROSS="${RED}[✘]${NC}"
INFO="${CYAN}[✦]${NC}"
GEAR="${YELLOW}[⚙]${NC}"

# ---------- OS DETECTION (UBUNTU + DEBIAN) ----------
detect_os() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        if [[ "$ID" == "ubuntu" || "$ID" == "debian" ]]; then
            echo -e "${TICK} Detected OS: ${WHITE}$NAME ($ID)${NC}"
        else
            echo -e "${CROSS} Error: Your OS is $ID. This script is only for Ubuntu or Debian!"
            exit 1
        fi
    else
        echo -e "${CROSS} Error: OS detection failed."
        exit 1
    fi
}

# ---------- BANNER ----------
banner() {
clear
echo -e "${CYAN}${BOLD}"
cat <<'EOF'
 ██████╗██████╗  ██████╗  █████╗ ███╗   ███╗███████╗██████╗ 
██╔════╝██╔══██╗██╔════╝ ██╔══██╗████╗ ████║██╔════╝██╔══██╗
╚█████╗ ██║  ██║██║  ███╗███████║██╔████╔██║█████╗  ██████╔╝
 ╚════██║██║  ██║██║   ██║██╔══██║██║╚██╔╝██║██╔══╝  ██╔══██╗
██████╔╝██████╔╝╚██████╔╝██║  ██║██║ ╚═╝ ██║███████╗██║  ██║
╚═════╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝╚═╝  ╚═╝
EOF
echo -e "${NC}${MAGENTA}  ✦ PTERODACTYL EXTRA BLUEPRINT EXTENTION INSTALLER ✦ ${NC}"
echo -e "${WHITE}  ─────────────────────────────────────────────────── ${NC}"
echo
}

# ---------- EXECUTION ----------
detect_os
banner

echo -e "${INFO} Starting Pterodactyl Extension Installation...\n"

# Move to directory
cd /var/www/pterodactyl || { echo -e "${CROSS} Pterodactyl directory not found!"; exit 1; }

# Update and install dependencies
echo -e "${GEAR} Checking and installing dependencies (git, unzip)..."
apt update -y > /dev/null 2>&1 && apt install git unzip -y > /dev/null 2>&1
echo -e "${TICK} Dependencies installed!"

# -------------------------------------------------------
# CLEANUP OLD FILES
# -------------------------------------------------------
if [ -d "temp_ext" ]; then
    echo -e "${GEAR} Cleaning up old temp files..."
    rm -rf temp_ext
fi

# Clone NEW repository
echo -e "${GEAR} Downloading latest extension files..."
git clone https://github.com/sdgamer8263-sketch/pterodactyl_extention1.git temp_ext > /dev/null 2>&1
echo -e "${TICK} Download complete!\n"

# =======================================================
# SELECTION MENU (INSIDE 'ex' FOLDER)
# =======================================================

# Check if 'ex' folder exists
if [ ! -d "temp_ext/ex" ]; then
    echo -e "${CROSS} Error: 'ex' folder not found in repository!"
    rm -rf temp_ext
    exit 1
fi

# Go inside 'ex' folder to list files
cd temp_ext/ex

# Enable nullglob to avoid errors if empty
shopt -s nullglob
files=( *.blueprint )
shopt -u nullglob

# Check if list is empty
if [ ${#files[@]} -eq 0 ]; then
    echo -e "${CROSS} No .blueprint files found inside 'ex' folder!"
    cd ../..
    rm -rf temp_ext
    exit 1
fi

# ---------- NEW POLISHED GRID MENU ----------
echo -e "${CYAN}╭────────────────────────────────────────────────────────────────────────╮${NC}"
echo -e "${CYAN}│${NC}  ${BOLD}${YELLOW}✨ Blueprint Extentions Menu (V26.1) ✨${NC}                               ${CYAN}│${NC}"
echo -e "${CYAN}├────────────────────────────────────────────────────────────────────────┤${NC}"

i=1
for file in "${files[@]}"; do
    # Formats to perfectly fit in the box and look clean
    printf "  ${GREEN}[%02d]${NC} ${WHITE}%-18s${NC}" "$i" "${file:0:18}"
    
    if (( i % 3 == 0 )); then
        echo ""
    fi
    ((i++))
done

# Check if the last row needs a new line
if (( (i - 1) % 3 != 0 )); then
    echo ""
fi
echo -e "${CYAN}╰────────────────────────────────────────────────────────────────────────╯${NC}\n"

echo -e "${WHITE}${BOLD}📌 How to install:${NC}"
echo -e " 🔸 ${CYAN}Single ID${NC}    : type ${GREEN}4${NC}"
echo -e " 🔸 ${CYAN}Multiple IDs${NC} : type ${GREEN}3,5,8${NC}"
echo -e " 🔸 ${CYAN}All Files${NC}    : type ${GREEN}all${NC}\n"
echo -ne "${MAGENTA}➤ Enter your choice: ${NC}"
read user_input
echo ""

# Function to install file
install_file() {
    local filename=$1
    echo -e "  ${GEAR} Installing ${WHITE}$filename${NC}..."
    cp "$filename" ../../
    echo -e "  ${TICK} ${GREEN}Success!${NC}"
}

# Logic to handle Input Cases
if [[ "$user_input" == "all" ]]; then
    echo -e "${INFO} Installing ALL extensions..."
    for file in "${files[@]}"; do
        install_file "$file"
    done
else
    IFS=',' read -ra ADDR <<< "$user_input"
    for index in "${ADDR[@]}"; do
        index=$(echo $index | xargs)
        
        if [[ "$index" =~ ^[0-9]+$ ]]; then
            real_index=$((index-1))
            
            if [ -n "${files[$real_index]}" ]; then
                file="${files[$real_index]}"
                install_file "$file"
            else
                echo -e "  ${CROSS} Skipping invalid ID: $index"
            fi
        else
            echo -e "  ${CROSS} Invalid input detected: $index"
        fi
    done
fi

# Go back to root and cleanup
cd ../..
rm -rf temp_ext
echo ""

# =======================================================
# FINALIZATION
# =======================================================

# Permissions
echo -e "${GEAR} Setting permissions..."
chown -R www-data:www-data /var/www/pterodactyl
chmod -R 755 /var/www/pterodactyl

# Optimization
echo -e "${GEAR} Applying changes & optimizing..."
php artisan migrate --force > /dev/null 2>&1
php artisan optimize:clear > /dev/null 2>&1
systemctl restart nginx

echo -e "${TICK} Pterodactyl extension backend ready!\n"

# Running the blueprint addon installer
echo -e "${INFO} Running Blueprint Addon Installer..."
yes | bash <(curl -fsSL https://raw.githubusercontent.com/sdgamer8263-sketch/pterodactyl_extention/main/addon-installer.sh)

echo -e "\n${TICK} ${BOLD}${GREEN}Installation complete! Ab flex karo 😎${NC}"
