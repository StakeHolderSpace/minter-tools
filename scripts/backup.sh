#!/usr/bin/env bash

DEBUG=false
MINTER_HOME=/home/minter
MINTER_DATA=${MINTER_HOME}/.minter
BACKUP_ROOT=${MINTER_HOME}/minter_backup
MINTER_HAS_ERRORS=true

# 0 code - errors not found!
sudo journalctl -u minter-node  -n 1000 | grep panic > /dev/null

[[ $? -eq 0 ]] && MINTER_HAS_ERRORS=false

[[ "$DEBUG" == "true" ]] && echo "MINTER_HAS_ERRORS=$MINTER_HAS_ERRORS"

if  [[ "$MINTER_HAS_ERRORS" == "false" ]]; then
  [[ "$DEBUG" == "true" ]] && echo "=========== Backup started ====="
  #
  [[ -d  ${BACKUP_ROOT}/ ]] || mkdir -p ${BACKUP_ROOT}/
  #
  [[ -d  ${BACKUP_ROOT}/config/ ]] && rm -rf ${BACKUP_ROOT}/config/
  #
  sudo systemctl stop  minter-node &&
  rsync -av --delete ${MINTER_DATA}/ ${BACKUP_ROOT}/ &&
  rm -rf ${BACKUP_ROOT}/config/ &&
  sudo systemctl start  minter-node
  #
  [[ "$DEBUG" == "true" ]] && echo "=========== Backup finished ====="

fi
