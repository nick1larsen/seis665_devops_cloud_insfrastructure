#!/bin/bash

# assign variables
ACTION=${1}

function default() {
# Update system packages
printf "Script Updating all system packages\n\n"
sudo yum update
printf "System package update complete\n\n\n"

# Install Nginx
printf "Scirpt Installing Nginx\n\n"
sudo amazon-linux-extras install nginx1.12 -y
printf "Nginx install complete\n\n\n"

# Configure Nginx to automatically start at system bootup
printf "Script Configuring Nginx to automatically start at system bootup\n\n"
sudo systemctl enable nginx.service
printf "Nginx auto start configuration complete\n\n\n"

# Copying documents from S3 to root directory
printf "Script Copying documents from S3 to root directory\n\n"
sudo aws s3 cp s3://lars6205-assignment-3/index.html /usr/share/nginx/html/index.html
printf "Copy complete\n\n\n"

# Starting nginx service
printf "Script starting nginx service"
sudo systemctl start nginx.service
printf "nginx service start complete\n\n\n"
}

function remove_nginx() {
# Stop nginx
printf "script Stopping nginx\n\n"
sudo systemctl stop nginx.service
printf "nginx server stopped\n\n\n"

# Delete files in nginx html root
printf "script Deleting files in  /usr/share/nginx/html\n\n"
sudo rm  /usr/share/nginx/html/*
printf "All files deleted\n\n\n"

# Uninstall nginx
printf "script Uninstalling nginx\n\n"
sudo yum remove nginx -y
printf "uninstall complete\n\n\n"
}

function version() {
# Display version
echo "1.0.0"
}

function display_help() {
#Display help message
cat << EOF
Usage: ${0} {-r|--remove|-v|--version|-h|--help|no args}

OPTIONS:
	-r | --remove	Stop nginx, delete files in web document root directory, uninstall nginx
	-v | --version	Display current version number
	-h | --help	Display command for help
	no args		Update system packages, installs nginx, configure nginx to automatically start on system bootup, copy documents from s3 directory to web document root directory, start nginx service

Examples:
	Stop/remove nginx
		$ ${0} -r
	Display current version number
		$ ${0} -v
	Display command for help
		$ ${0} -h
	no args
		$ ${0} 
EOF
}

case "$ACTION" in
	-r | --remove)
		remove_nginx
		;;
	-v | --version)
		version
		;;
	-h | --help)
		display_help
		;;
	*)
		default
	exit 1
esac
