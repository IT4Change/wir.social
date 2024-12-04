#!/bin/bash

# base setup
SCRIPT_PATH=$(realpath $0)
SCRIPT_DIR=$(dirname $SCRIPT_PATH)

case $1 in
    on)
        # set Neo4j in offline mode (maintenance)
        echo "Neo4j maintenance:  on"
        kubectl get --namespace=wir-social-ocelot-production statefulset ocelot-neo4j-neo4j -o json \
            | jq '.spec.template.spec.containers[] += {"command": ["tail", "-f", "/dev/null"]}' \
            | kubectl apply -f -

        # wait for the container to restart
        echo "Wait 60s ..."
        sleep 60
    ;;
    off)
        # set Neo4j in online mode
        echo "Neo4j maintenance:  off"
        kubectl get --namespace=wir-social-ocelot-production statefulset ocelot-neo4j-neo4j -o json \
            | jq 'del(.spec.template.spec.containers[].command)' \
            | kubectl apply -f -

        # wait for the container to restart
        echo "Wait 60s ..."
        sleep 60
    ;;
    *)
        echo -e "Run this script with first argument either 'off' or 'on'"
        exit
    ;;
esac
