#!/usr/bin/env bash
#
# Backup script for minter node
#

DEBUG=false
MINTER_HAS_ERRORS=false

BACKUP_SSH_HOST=u00000@u00000.your-backup.de
BACKUP_SSH_PORT=23
BACKUP_SSH_PRIVKEY_PATH=~/.ssh/id_rsa_storagebox
BACKUP_MINTER_DATA=${BACKUP_SSH_HOST}:./minter_backups

MINTER_HOME=/home/minter
MINTER_SERVICE_NAME=minter-node
MINTER_DATA=${MINTER_HOME}/.minter


# 0 code - errors not found!
sudo journalctl -u ${MINTER_SERVICE_NAME}  -n 500 | grep -q panic &&  MINTER_HAS_ERRORS=true
#
sudo chmod 0600 ${BACKUP_SSH_PRIVKEY_PATH}

[[ "$DEBUG" == "true" ]] && echo "MINTER_HAS_ERRORS=$MINTER_HAS_ERRORS"

#
if  [[ "$MINTER_HAS_ERRORS" == "false" ]] && [[ -d  ${MINTER_DATA}/ ]]; then

  [[ "$DEBUG" == "true" ]] && echo "=========== Backup started ====="
  #
  sudo systemctl stop  ${MINTER_SERVICE_NAME} &&
  rsync -av --delete --progress -e "ssh -p ${BACKUP_SSH_PORT} -i ${BACKUP_SSH_PRIVKEY_PATH}" --recursive --exclude  'config/' ${MINTER_DATA}/  ${BACKUP_MINTER_DATA}/
  sudo systemctl start  ${MINTER_SERVICE_NAME}
  #
  [[ "$DEBUG" == "true" ]] && echo "=========== Backup finished ====="

fi
