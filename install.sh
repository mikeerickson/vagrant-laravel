#!/usr/bin/env bash

#### FUNCTIONS
#    functions used in this script
function section_header() {
	purple='\e[0;35m' # purple
	NC='\e[0m'        # No Color
	echo -e "${purple} --- $1 --- ${NC}"
}

#### BEGIN SCRIPT

section_header "Updating Package List"
sudo apt-get update

section_header "Initializing MySQL and Install Base Packages"
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
sudo apt-get install -y vim curl python-software-properties

section_header "Updating Package List"
sudo apt-get update

section_header "Load latest PHP"
sudo add-apt-repository -y ppa:ondrej/php5

section_header "Updating Package List"
sudo apt-get update

section_header "Installing PHP-specific Packages"
sudo apt-get install -y php5 apache2 libapache2-mod-php5 php5-curl php5-gd php5-mcrypt mysql-server-5.5 php5-mysql git-core

section_header "Installing and configuring xDebug"
sudo apt-get install -y php5-xdebug

cat << EOF | sudo tee -a /etc/php5/mods-available/xdebug.ini
xdebug.scream=1
xdebug.cli_color=1
xdebug.show_local_vars=1
xdebug.remote_enable = on
xdebug.remote_handler = dbgp
xdebug.remote_connect_back = on
EOF

section_header "Enabling mod-rewrite"
sudo a2enmod rewrite

section_header "Setting document root"
sudo rm -rf /var/www
sudo ln -fs /vagrant/public /var/www


sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php5/apache2/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php5/apache2/php.ini
sudo sed -i 's/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf

section_header "Restarting Apache"
sudo service apache2 restart

section_header "Installing Composer"
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

# Laravel stuff here, if you want
echo "CREATE DATABASE IF NOT EXISTS vagrant" | mysql -uroot -proot

section_header "Migrating and Seeding Default Database"
cd /vagrant
chmod -R 777 app/storage
php artisan migrate --seed

section_header "Configuration Complete, Vagrant Box Ready!"
