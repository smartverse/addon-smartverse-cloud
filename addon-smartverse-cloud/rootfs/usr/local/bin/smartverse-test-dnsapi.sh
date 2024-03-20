#!/usr/bin/env bash

SCRIPT_DIR=$(dirname "$0")
CONF_DIR="/etc/smartverse"
INSTANCE="$CONF_DIR/instance.json"

if ! [ -f $INSTANCE ]; then
    echo "File $INSTANCE not found"
    exit 1;
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

export CERTBOT_DOMAIN=$DOMAIN
export CERTBOT_VALIDATION='SOME_TEST_LINE'

$SCRIPT_DIR/smartverse-txt.sh
$SCRIPT_DIR/smartverse-cleanup.sh
