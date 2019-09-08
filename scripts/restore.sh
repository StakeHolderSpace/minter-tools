#!/usr/bin/env bash
#
# Restore Backup script for minter node
#

DEBUG=false

BACKUP_SSH_HOST=minter@127.0.0.1
BACKUP_SSH_PORT=55422
BACKUP_SSH_PRIVKEY_PATH=~/.ssh/id_rsa_minter

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
rsync -chavzP --progress -e "ssh -p ${BACKUP_SSH_PORT} -i ${BACKUP_SSH_PRIVKEY_PATH}" --recursive ${BACKUP_MINTER_DATA}/ ${MINTER_DATA}/ &&
chown -R minter:minter ${MINTER_DATA}
#
echo "###########################################################################"
echo ""
echo " Do shell command if need: 'sudo systemctl restart  ${MINTER_SERVICE_NAME}'"
echo ""
echo "###########################################################################"
#
[[ "$DEBUG" == "true" ]] && echo "====== Restore finished ====="

