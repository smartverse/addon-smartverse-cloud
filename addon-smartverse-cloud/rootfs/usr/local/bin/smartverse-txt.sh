#!/usr/bin/env bash

python3 -m smartverse_tools.smartverse_api -d $CERTBOT_DOMAIN -t $CERTBOT_VALIDATION set-dns-challenge
