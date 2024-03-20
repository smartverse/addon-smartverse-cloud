#!/usr/bin/env bash

certbot -q renew --no-random-sleep-on-renew --preferred-challenges dns --manual-auth-hook "/usr/local/bin/smartverse-txt.sh" --manual-cleanup-hook "/usr/local/bin/smartverse-cleanup.sh"
