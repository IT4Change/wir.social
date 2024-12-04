#!/bin/sh

# base setup
SCRIPT_PATH=$(realpath $0)
SCRIPT_DIR=$(dirname $SCRIPT_PATH)

case $1 in
    on)
        echo "Network maintenance:  on"
        kubectl patch --namespace=wir-social-ocelot-production ingress wir-social --type merge --patch-file ${SCRIPT_DIR}/../patches/patch.ingress.maintenance.on.yaml
    ;;
    off)
        echo "Network maintenance:  off"
        kubectl patch --namespace=wir-social-ocelot-production ingress wir-social --type merge --patch-file ${SCRIPT_DIR}/../patches/patch.ingress.maintenance.off.yaml
    ;;
    *)
        echo -e "Run this script with first argument either 'on' or 'off'"
        exit
    ;;
esac