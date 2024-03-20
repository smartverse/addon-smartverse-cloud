#!/usr/bin/env bashio
####!/command/with-contenv bashio
# shellcheck shell=bash
# shellcheck disable=SC2207
# ==============================================================================
#
#
# ==============================================================================
#if bashio::var.false "$(bashio::addon.protected)"; then
#    bashio::log.info 'Smartverse support has been enabled.'
#fi

SCRIPT_DIR=$(dirname "$0")

export USERNAME=$(bashio::config 'username')
export PASSWORD=$(bashio::config 'password')

if [[ $USERNAME == "" || $USERNAME == "null" ]]; then
    bashio::log.error 'Username is not set. BOTH username AND password OR login TOKEN must be provided for api to login'
    exit 1
fi

if [[ $PASSWORD == "" || $PASSWORD == "null" ]]; then
    bashio::log.error 'Password is not set. BOTH username AND password OR login TOKEN must be provided for api to login'
    exit 1
fi

bashio::log.info "Logging into SMARTVERSE as $USERNAME"

if ! [ -d /data ]; then
    bashio::log.error 'HASS data dir does not exists? Not a HA install?'
    exit 1
fi;

ln -s /data /etc/smartverse

python3 -m smartverse_tools.smartverse_api -u $USERNAME -p $PASSWORD -s login

if [ "$?" != "0" ]; then
    bashio::log.error 'API login did not suceeded'
    exit $?
fi;

python3 -m smartverse_tools.smartverse_api -s register-instance

if [ "$?" != "0" ]; then
    bashio::log.error 'Failed to register instance, code: $?'
    exit $?
fi;

$SCRIPT_DIR/smartverse-test-dnsapi.sh

if [ "$?" != "0" ]; then
    bashio::log.error 'Failed to test dnsapi, code: $?'
    exit $?
fi;

$SCRIPT_DIR/certbot-getcert.sh

if [ "$?" != "0" ]; then
    bashio::log.error 'Failed to get letsencrypt certificate, code: $?'
    cat /var/log/letsencrypt/letsencrypt.log
    exit $?
fi;

$SCRIPT_DIR/smartverse-connect.sh
