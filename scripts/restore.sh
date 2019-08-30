#!/usr/bin/env bash
#
# Restore Backup script for minter node
#

DEBUG=false

BACKUP_SSH_HOST=minter@192.168.1.1
BACKUP_SSH_PORT=55422

MINTER_HOME=/home/minter
MINTER_SERVICE_NAME=minter-node
MINTER_DATA=${MINTER_HOME}/.minter

BACKUP_MINTER_DATA=${BACKUP_SSH_HOST}:${MINTER_HOME}/minter_backups


[[ "$DEBUG" == "true" ]] && echo "====== Restore started ====="

#
[[ -d  ${MINTER_DATA}/data/ ]] || mkdir -p ${MINTER_DATA}/data/
[[ -d  ${MINTER_DATA}/tmdata/ ]] || mkdir -p ${MINTER_DATA}/tmdata/
#
sudo systemctl stop  ${MINTER_SERVICE_NAME}  &&
rsync -chavzP -e "ssh -p ${BACKUP_SSH_PORT}" ${BACKUP_MINTER_DATA}/data/ ${MINTER_DATA}/data/ &&
rsync -chavzP -e "ssh -p ${BACKUP_SSH_PORT}" ${BACKUP_MINTER_DATA}/tmdata/  ${MINTER_DATA}/tmdata/ &&
chown -R minter:minter ${MINTER_DATA}
#
echo "###########################################################################"
echo ""
echo "Do shell command if need: 'sudo systemctl restart  ${MINTER_SERVICE_NAME}'"
echo ""
echo "###########################################################################"
#
[[ "$DEBUG" == "true" ]] && echo "====== Restore finished ====="

