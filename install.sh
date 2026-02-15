#!/bin/bash

# Panel directory তে যাও
cd /var/www/pterodactyl || exit 1

# আপডেট আর প্রয়োজনীয় প্যাকেজ ইনস্টল
apt update -y
apt install git unzip -y

# GitHub থেকে এক্সটেনশন ক্লোন করো
git clone https://github.com/sdgamer8263-sketch/pterodactyl_extention.git temp_ext

# এক্সটেনশন ফাইলগুলো প্যানেলে কপি করো
cp -r temp_ext/* .

# অস্থায়ী ফোল্ডার মুছে ফেলো
rm -rf temp_ext

# ক্যাশ ক্লিয়ার আর মাইগ্রেশন
php artisan migrate --force
php artisan optimize:clear

# পারমিশন ঠিক করো
chown -R www-data:www-data /var/www/pterodactyl

# Nginx রিস্টার্ট করো
systemctl restart nginx

echo "Installation complete!"
