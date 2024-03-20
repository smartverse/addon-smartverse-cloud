#!/bin/bash
####!/command/with-contenv bashio
# shellcheck shell=bash
# shellcheck disable=SC2207
# ==============================================================================
#
#
# ==============================================================================

CONF_DIR="/etc/smartverse"
SCRIPT_DIR=$(dirname "$0")

ACCESS="$CONF_DIR/access.json"
INSTANCE="$CONF_DIR/instance.json"

if ! [ -f $ACCESS ]; then
    #bashio::log.warning "Config file does not exists"
    echo "Access config file does not exists"
    exit 1
fi;

if ! [ -f $INSTANCE ]; then
    #bashio::log.warning "Config file does not exists"
    echo "Instance config file does not exists"
    exit 1
fi;

if ! [ -e /data/letsencrypt ]; then
    mkdir /data/letsencrypt
fi;

if ! [ -e /etc/letsencrypt.orig ]; then
    mv /etc/letsencrypt /etc/letsencrypt.orig
fi;

if ! [ -e /etc/letsencrypt ]; then
    ln -s /data/letsencrypt /etc/letsencrypt
fi;

DOMAIN=$(jq --raw-output ".domain // empty" $INSTANCE)
EMAIL=$(jq --raw-output ".email // empty" $INSTANCE)

if [ $DOMAIN == "" ] ; then
    echo "Domain cannot be read"
    exit 1
fi;

if [ $EMAIL == "" ] ; then
    echo "EMAIL cannot be read"
    exit 1
fi;

echo "Domain: $DOMAIN"
echo "Email: $EMAIL"

certbot certonly --manual \
    -d $DOMAIN \
    --preferred-challenges dns \
    --manual-auth-hook "$SCRIPT_DIR/smartverse-txt.sh" \
    --manual-cleanup-hook "$SCRIPT_DIR/smartverse-cleanup.sh" \
    --non-interactive --agree-tos -m $EMAIL
