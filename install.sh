#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e 

# Colors for better output visibility
GREEN='\033[0;32m'
CYAN='\033[0;36m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# ==========================================
# SDGAMER BANNER
# ==========================================
echo -e "${CYAN}"
echo "  ____  ____   ____    _    __  __ _____ ____  "
echo " / ___||  _ \ / ___|  / \  |  \/  | ____|  _ \ "
echo " \___ \| | | | |  _  / _ \ | |\/| |  _| | |_) |"
echo "  ___) | |_| | |_| |/ ___ \| |  | | |___|  _ < "
echo " |____/|____/ \____/_/   \_\_|  |_|_____|_| \_\\"
echo -e "${NC}"

echo -e "${GREEN}=======================================================${NC}"
echo -e "${GREEN}        Hyper Utility - Secure Installer Script        ${NC}"
echo -e "${GREEN}=======================================================${NC}"
echo -e "${YELLOW}⚠️ WARNING: Please run this utility as the 'root' user.${NC}"
sleep 1

# ==========================================
# SECURITY: SCRIPT LICENSE KEY CHECK
# ==========================================
# The actual key (ai9cU0$pJu4cY_T) is encoded in Hex format to keep it hidden.
_SECRET="\x61\x69\x39\x63\x55\x30\x24\x70\x4a\x75\x34\x63\x59\x5f\x54"
DECODED_SECRET=$(printf "%b" "$_SECRET")

echo -e "\n${YELLOW}🔒 SECURITY CHECK: This script requires a valid license key to run.${NC}"
# Use -s to hide the input characters on the screen like a password
read -s -p "Enter your License Key: " USER_INPUT_KEY
echo ""

if [ "$USER_INPUT_KEY" != "$DECODED_SECRET" ]; then
    echo -e "${RED}❌ ERROR: Invalid License Key! Access Denied.${NC}"
    echo -e "${CYAN}Please contact SDGAMER to get a valid key.${NC}"
    exit 1
else
    echo -e "${GREEN}✅ License Verified! Starting Hyper Utility Installation...${NC}"
    sleep 2
fi

# ==========================================
# HYPER UTILITY DOWNLOADING & EXECUTION
# ==========================================
echo -e "${CYAN}-> Checking required packages...${NC}"
apt-get update -y > /dev/null 2>&1
apt-get install -y wget curl > /dev/null 2>&1

echo -e "${CYAN}-> Downloading Hyper Utility...${NC}"
wget -q --show-progress https://hyper-r2.dgenx.net/hyperv1/hyper-utility -O hyper-utility

echo -e "${CYAN}-> Making the file executable...${NC}"
chmod +x hyper-utility

echo -e "${GREEN}=======================================================${NC}"
echo -e "${GREEN}  Download Complete! 🎉 Launching Hyper Utility...     ${NC}"
echo -e "${GREEN}=======================================================${NC}"
sleep 2

# Launch the interactive menu
./hyper-utility
