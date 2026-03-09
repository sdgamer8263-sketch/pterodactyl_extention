# =======================================
#   AUTHOR    : SDGAMER
#   TOOL      : PTERODACTYL EXTRA BLUEPRINT EXTENTION INSTALLER
# =======================================

# ---------- COLORS ----------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

# ---------- OS DETECTION (UBUNTU + DEBIAN) ----------
detect_os() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        if [[ "$ID" == "ubuntu" || "$ID" == "debian" ]]; then
            echo -e "${GREEN}Detected OS: $NAME ($ID)${NC}"
        else
            echo -e "${RED}Error: Your OS is $ID. This script is only for Ubuntu or Debian!${NC}"
            exit 1
        fi
    else
        echo -e "${RED}Error: OS detection failed.${NC}"
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
echo -e "${GREEN}      PTERODACTYL EXTRA BLUEPRINT EXTENTION INSTALLER (WITHOUT SFTP) ${NC}"
echo "======================================="
echo
}

# ---------- EXECUTION ----------
detect_os
banner

echo -e "${YELLOW}Starting Pterodactyl Extension Installation...${NC}"

# Move to directory
cd /var/www/pterodactyl || { echo -e "${RED}Pterodactyl directory not found!${NC}"; exit 1; }

# Update and install dependencies
apt update -y && apt install git unzip -y

# -------------------------------------------------------
# CLEANUP OLD FILES
# -------------------------------------------------------
if [ -d "temp_ext" ]; then
    echo -e "${YELLOW}Cleaning up old temp files...${NC}"
    rm -rf temp_ext
fi

# Clone repository fresh
echo -e "${YELLOW}Downloading latest extension files...${NC}"
git clone https://github.com/sdgamer8263-sketch/pterodactyl_extention1/tree/main/ex.git temp_ext

# =======================================================
#                  SELECTION MENU
# =======================================================

cd temp_ext

# Enable nullglob so if no matches found, array is empty
shopt -s nullglob
# Filter strictly for .blueprint files
files=( *.blueprint )
shopt -u nullglob

cd ..

# Check if any blueprint files were found
if [ ${#files[@]} -eq 0 ]; then
    echo -e "${RED}No .blueprint files found in the repository!${NC}"
    rm -rf temp_ext
    exit 1
fi

echo -e "\n${CYAN}Available Blueprint Extensions:${NC}"
i=1
for file in "${files[@]}"; do
    echo -e "${GREEN}[$i]${NC} $file"
    ((i++))
done

echo -e "\n${YELLOW}Select installation mode:${NC}"
echo -e " - ${GREEN}Single ID${NC} (e.g., 4)"
echo -e " - ${GREEN}Multiple IDs${NC} (e.g., 3,5,8)"
echo -e " - ${GREEN}All Files${NC} (type 'all')"
echo -n "Enter your choice: "
read user_input

# Function to install file (Copy .blueprint to root)
install_file() {
    local filename=$1
    echo -e "${YELLOW}Installing Blueprint: $filename...${NC}"
    cp "temp_ext/$filename" .
}

# Logic to handle Input Cases
if [[ "$user_input" == "all" ]]; then
    # CASE 3: Install ALL
    echo -e "${GREEN}Installing ALL extensions...${NC}"
    for file in "${files[@]}"; do
        install_file "$file"
    done
else
    # CASES 1 & 2: Single or Multiple (Comma separated)
    IFS=',' read -ra ADDR <<< "$user_input"
    for index in "${ADDR[@]}"; do
        # Clean whitespace
        index=$(echo $index | xargs)
        
        if [[ "$index" =~ ^[0-9]+$ ]]; then
            real_index=$((index-1))
            
            if [ -n "${files[$real_index]}" ]; then
                file="${files[$real_index]}"
                install_file "$file"
            else
                echo -e "${RED}Skipping invalid ID: $index${NC}"
            fi
        else
            echo -e "${RED}Invalid input detected: $index${NC}"
        fi
    done
fi

# Clean up temp folder
rm -rf temp_ext

# =======================================================
# FINALIZATION
# =======================================================

# Permissions
chown -R www-data:www-data /var/www/pterodactyl
chmod -R 755 /var/www/pterodactyl

# Optimization
echo -e "${YELLOW}Applying changes...${NC}"
php artisan migrate --force
php artisan optimize:clear
systemctl restart nginx

echo -e "${GREEN}Pterodactyl extension complete!${NC}"

# Running the blueprint addon installer
echo -e "${CYAN}Running Blueprint Addon Installer...${NC}"
yes | bash <(curl -fsSL https://raw.githubusercontent.com/sdgamer8263-sketch/pterodactyl_extention/main/addon-installer.sh)

echo -e "\n${GREEN}Installation complete! Ab flex karo 😎${NC}"
