#!/bin/bash

# assign variables
ACTION=${1}
VERSION="0.5.0"

function create() {
curl http://169.254.169.254/latest/dynamic/instance-identity/document/ > backend1-identity.json
curl -vs https://s3.amazonaws.com/seis665/message.json 2>&1 | tee backend1-message.txt
sudo cp /var/log/nginx/access.log access.log
}

function version() {
echo $VERSION
}

function help() {
cat << EOF
Usage: ${0} {-c|--create|-v|--version|-h|--help}

OPTIONS:
	-c|--create 	Create identity file, message file, and copy log to pwd
	-v|--version	Get version number
	-h|--help	Get help message
EOF
}

case "$ACTION" in
	-c|--create)
		create
		;;
	-v|version)
		version
		;;
	-h|--help)
		help
		;;
	*)
	echo "Usage ${0} {-c|-v|-h}"
	exit 1
esac
