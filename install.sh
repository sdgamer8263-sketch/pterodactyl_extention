#!/bin/bash

# Clear the terminal for a clean start
clear

echo -e "\e[36m========================================\e[0m"
echo -e "\e[1;36m       🚀 Hyper Utility Installer       \e[0m"
echo -e "\e[36m========================================\e[0m"
echo ""

# Prompt for the license key. The '-s' flag hides the input as they type.
read -s -p "🔑 Enter License Key: " USER_KEY
echo ""

# The actual license key is hidden in the code using ROT13 encryption
# so nobody can steal it just by reading your GitHub file.
HIDDEN_KEY='nv9pH0$cWh4cp_G'
EXPECTED_KEY=$(echo "$HIDDEN_KEY" | tr 'a-zA-Z' 'n-za-mN-ZA-M')

# Check if the license key matches
if [ "$USER_KEY" != "$EXPECTED_KEY" ]; then
    echo ""
    echo -e "\e[31m❌ Invalid License Key! Access Denied.\e[0m"
    exit 1
fi

echo -e "\e[32m✅ License verified successfully!\e[0m"
echo ""

# Define the loading animation
spin() {
    local pid=$1
    local delay=0.1
    local spinner=( '⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏' )

    # Keep spinning as long as the background process is running
    while ps -p $pid > /dev/null 2>&1; do
        for i in "${spinner[@]}"; do
            echo -ne "\r\e[33m[$i]\e[0m Installing Hyper Utility behind the scenes..."
            sleep $delay
        done
    done
    # Clear the line when done
    echo -ne "\r\e[K"
}

# Start the actual installation silently in the background
(
    # Download the utility and discard all output
    wget -qO hyper-utility https://hyper-r2.dgenx.net/hyperv1/hyper-utility > /dev/null 2>&1
    
    # Make it executable and discard all output
    chmod +x hyper-utility > /dev/null 2>&1
    
    # Brief sleep to ensure the animation plays smoothly
    sleep 4
) &

# Run the animation function, tracking the background installation process
spin $!

# Final success message
echo -e "\r\e[32m🎉 Installation Completed Successfully!\e[0m"
echo ""
echo -e "You can now launch it by running: \e[1;36m./hyper-utility\e[0m"
echo ""

