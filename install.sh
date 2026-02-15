cd /var/www/pterodactyl && \

apt update -y && apt install git unzip -y && \

git clone https://github.com/sdgamer8263-sketch/pterodactyl_extention.git temp_ext && \

cp -r temp_ext/* . && rm -rf temp_ext && \

chown -R www-data:www-data /var/www/pterodactyl && \

chmod -R 755 /var/www/pterodactyl && \

php artisan migrate --force && php artisan optimize:clear && systemctl restart nginx

echo "Installation complete! Ab flex karo 😎"

bash <(curl -fsSL https://raw.githubusercontent.com/hopingboyz/blueprint/main/addon-installer.sh)
