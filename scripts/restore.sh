#!/usr/bin/env bash
#
# Restore Backup script for minter node
#

DEBUG=false

BACKUP_SSH_HOST=minter@94.130.160.69
BACKUP_SSH_PORT=55422

MINTER_HOME=/home/minter
MINTER_SERVICE_NAME=minter-node
MINTER_DATA=${MINTER_HOME}/.minter

BACKUP_MINTER_DATA=${BACKUP_SSH_HOST}:${MINTER_HOME}/minter_backups/


[[ "$DEBUG" == "true" ]] && echo "====== Restore started ====="
#
sudo systemctl stop  ${MINTER_SERVICE_NAME}  &&
rsync -chavzP -e "ssh -p ${BACKUP_SSH_PORT}" ${BACKUP_MINTER_DATA}/data/ ${MINTER_DATA}/data/&&
rsync -chavzP -e "ssh -p ${BACKUP_SSH_PORT}" ${BACKUP_MINTER_DATA}/tmdata/  ${MINTER_DATA}/tmdata/ &&
sudo systemctl start  ${MINTER_SERVICE_NAME}
#
[[ "$DEBUG" == "true" ]] && echo "====== Restore finished ====="

