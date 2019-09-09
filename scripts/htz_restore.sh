#!/usr/bin/env bash
#
# Restore script for minter node
# read  before use: https://wiki.hetzner.de/index.php/Backup_Space_SSH_Keys/ru
#

DEBUG=false

BACKUP_SSH_HOST=u00000@u00000.your-backup.de
BACKUP_SSH_PORT=23
BACKUP_SSH_PRIVKEY_PATH=~/.ssh/id_rsa_storagebox
BACKUP_MINTER_DATA=${BACKUP_SSH_HOST}:./minter_backups

MINTER_HOME=/home/minter
MINTER_SERVICE_NAME=minter-node
MINTER_DATA=${MINTER_HOME}/.minter

[[ "$DEBUG" == "true" ]] && echo "====== Restore started ====="

#
[[ -d  ${MINTER_DATA}/data/ ]] || mkdir -p ${MINTER_DATA}/data/
[[ -d  ${MINTER_DATA}/tmdata/ ]] || mkdir -p ${MINTER_DATA}/tmdata/

#
sudo systemctl stop  ${MINTER_SERVICE_NAME}  &&
rsync -havzP -e "ssh -p ${BACKUP_SSH_PORT} -i ${BACKUP_SSH_PRIVKEY_PATH}" --progress --delete  --exclude "config/" --recursive ${BACKUP_MINTER_DATA}/ ${MINTER_DATA}/ &&
chown -R minter:minter ${MINTER_DATA}
#
echo "###########################################################################"
echo ""
echo " Do shell command if need: 'sudo systemctl restart  ${MINTER_SERVICE_NAME}'"
echo ""
echo "###########################################################################"
#
[[ "$DEBUG" == "true" ]] && echo "====== Restore finished ====="

