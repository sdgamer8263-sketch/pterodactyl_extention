# ======================================================================
#   AUTHOR    : SDGAMER
#   TOOL      : PTERODACTYL EXTRA BLUEPRINT EXTENTIONS INSTALLER
# ======================================================================

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

# Clone NEW repository
echo -e "${YELLOW}Downloading latest extension files from 'pterodactyl_extention1'...${NC}"
git clone https://github.com/sdgamer8263-sketch/pterodactyl_extention1.git temp_ext

# =======================================================
# SELECTION MENU (INSIDE 'ex' FOLDER)
# =======================================================

# Check if 'ex' folder exists
if [ ! -d "temp_ext/ex" ]; then
    echo -e "${RED}Error: 'ex' folder not found in repository!${NC}"
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
    echo -e "${RED}No .blueprint files found inside 'ex' folder!${NC}"
    cd ../..
    rm -rf temp_ext
    exit 1
fi

echo -e "\n${CYAN}Available Extensions (in 'ex' folder):${NC}"
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

# Function to install file
install_file() {
    local filename=$1
    echo -e "${YELLOW}Installing: $filename...${NC}"
    # Copy from current directory (temp_ext/ex) to Pterodactyl root (/var/www/pterodactyl)
    cp "$filename" ../../
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

# Go back to root and cleanup
cd ../..
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

