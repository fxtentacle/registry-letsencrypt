#!/usr/bin/env bash
log_lvl_info() {
    NOW=$(date +"%Y/%m/%d %H:%M:%S")
    echo "${NOW} [info] ${1}"
}

log_lvl_error() {
    NOW=$(date +"%Y/%m/%d %H:%M:%S")
    echo "${NOW} [error] ${1}"
}

checkauth() {
    log_lvl_info "Checking authentication configuration..."
    if [[ ! -d conf/auth ]]; then
        createuser
    else
        if [[ ! -f conf/auth/htpasswd ]]; then
            createuser
        fi
    fi
    log_lvl_info "Completed"
}

createuser() {
    echo "Please enter credentials for your registry login"
    mkdir -p conf/auth
    echo "Username"
    read username
    echo -n "Password":
    read -s password
    htpasswd -Bbn ${username} ${password} > conf/auth/htpasswd
    log_lvl_info "Authentication configuration completed."
}

###########################
#        MAIN
###########################

#check if a domain name is passed to the function
if [[ -z "$1" ]]; then
    log_lvl_error "Please specify a domain name (e.g. example.com) as first parameter. \n
     The second paramter should be the email address as second parameter.\n
     For example: ${0} example.com example@example.com"
    exit
fi

export DOCKER_REGISTRY_DOMAIN_NAME=$1
export DOCKER_REGISTRY_CERT_EMAIL_ADDRESS=$2
checkauth
docker-compose up -d
