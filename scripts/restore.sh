#!/bin/sh

# base setup
SCRIPT_PATH=$(realpath $0)
SCRIPT_DIR=$(dirname $SCRIPT_PATH)

# configuration
BACKUP_DATE="2024-12-04_09-39-10"
BACKUP_FOLDER=${BACKUP_FOLDER:-${SCRIPT_DIR}/../backup/${BACKUP_DATE}}

printf "Backup folder:  %s\n" $BACKUP_FOLDER

${SCRIPT_DIR}/maintenance.sh on
${SCRIPT_DIR}/neo4j.sh on

# copy neo4j backup from local drive
echo "Copying database from local file system ..."
kubectl cp \
    $BACKUP_FOLDER/neo4j-dump \
    wir-social-ocelot-production/$(kubectl --namespace=wir-social-ocelot-production get pods | grep ocelot-neo4j |awk '{ print $1 }'):/var/lib/neo4j/$BACKUP_DATE-neo4j-dump

# copy image data
echo "Copying public uploads to local file system ..."
kubectl cp \
    $BACKUP_FOLDER/public-uploads/. \
    wir-social-ocelot-production/$(kubectl --namespace=wir-social-ocelot-production get pods | grep wir-social-backend |awk '{ print $1 }'):/app/public/uploads/

# restore database
echo "Restoring Database ..."
kubectl --namespace=wir-social-ocelot-production exec -it \
    $(kubectl --namespace=wir-social-ocelot-production get pods | grep ocelot-neo4j | awk '{ print $1 }') \
    -- neo4j-admin load --from=/var/lib/neo4j/$BACKUP_DATE-neo4j-dump --force

${SCRIPT_DIR}/neo4j.sh off
${SCRIPT_DIR}/maintenance.sh off