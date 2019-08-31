#!/usr/bin/env bash
#
# Backup script for minter node
#

DEBUG=false
HOSTNAME=`hostname`
MINTER_HOME=/home/minter
MINTER_SERVICE_NAME=minter-node
MINTER_DATA=${MINTER_HOME}/.minter
BACKUP_ROOT=${MINTER_HOME}/minter_backups
MINTER_HAS_ERRORS=false


# 0 code - errors not found!
sudo journalctl -u ${MINTER_SERVICE_NAME}  -n 500 | grep -q panic &&  MINTER_HAS_ERRORS=true

[[ "$DEBUG" == "true" ]] && echo "MINTER_HAS_ERRORS=$MINTER_HAS_ERRORS"

if  [[ "$MINTER_HAS_ERRORS" == "false" ]]; then
  [[ "$DEBUG" == "true" ]] && echo "=========== Backup started ====="
  #
  [[ -d  ${BACKUP_ROOT}/ ]] || mkdir -p ${BACKUP_ROOT}/
  #
  [[ -d  ${BACKUP_ROOT}/config/ ]] && rm -rf ${BACKUP_ROOT}/config/
  #
  sudo systemctl stop  ${MINTER_SERVICE_NAME} &&
  rsync -av --delete --exclude 'config/' ${MINTER_DATA}/ ${BACKUP_ROOT}/ &&
  rm -rf ${BACKUP_ROOT}/config/ &&
  sudo systemctl start  ${MINTER_SERVICE_NAME}
  #
  [[ "$DEBUG" == "true" ]] && echo "=========== Backup finished ====="

fi
