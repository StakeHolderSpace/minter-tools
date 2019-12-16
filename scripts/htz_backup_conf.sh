#!/usr/bin/env bash
#
# Backup script for minter node
# read  before use: https://wiki.hetzner.de/index.php/Backup_Space_SSH_Keys/ru
#

DEBUG=false
MINTER_HAS_ERRORS=false

BACKUP_SSH_HOST=u00000@u00000.your-backup.de
BACKUP_SSH_PORT=23
BACKUP_SSH_PRIVKEY_PATH=~/.ssh/id_rsa_storagebox
BACKUP_SSH_REMOTE_DIR=./${HOSTNAME}
BACKUP_SSH_REMOTE_PATH=${BACKUP_SSH_HOST}:${BACKUP_SSH_REMOTE_DIR}


MINTER_HOME=/home/minter
MINTER_SERVICE_NAME=minter-node
MINTER_CONFIG=${MINTER_HOME}/.minter/config

sudo chmod 0600 ${BACKUP_SSH_PRIVKEY_PATH}

#
if  [[ -d  ${MINTER_CONFIG}/ ]]; then

  [[ "$DEBUG" == "true" ]] && echo "=========== Backup started ====="
  #
  rsync -av -e "ssh -p ${BACKUP_SSH_PORT} -i ${BACKUP_SSH_PRIVKEY_PATH}" \
    --progress  --delete \
    --include "config.toml" \
    --include "node_key.json" \
    --include "priv_validator.json" \
    --exclude="*" \
    ${MINTER_CONFIG}/  ${BACKUP_SSH_REMOTE_PATH}/
  #
  [[ "$DEBUG" == "true" ]] && echo "=========== Backup finished ====="

fi
