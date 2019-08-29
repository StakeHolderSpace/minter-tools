#!/bin/bash
# A menu driven shell script sample template
## ----------------------------------
# Step #1: Define variables
# ----------------------------------
BASEDIR=$(dirname "$(readlink -f $0)")
SCRIPTS_DIR=${BASEDIR}/scripts
MINTER_HOME=/home/minter
MINTER_SERVICE_NAME=minter-node

RED='\033[0;41;30m'
STD='\033[0;0;39m'

# ----------------------------------
# Step #2: User defined function
# ----------------------------------
pause(){
  read -p "Press [Enter] key to continue..." pressedKey
}

watch_journal(){
  sudo journalctl -u ${MINTER_SERVICE_NAME}  -n 100 -f
  pause
}

show_journal(){
  sudo journalctl -u ${MINTER_SERVICE_NAME}  -n 300
  pause
}

stop_minter(){
  sudo systemctl stop  ${MINTER_SERVICE_NAME}
  pause
}

restart_minter(){
  sudo systemctl restart  ${MINTER_SERVICE_NAME}
  pause
}

show_node_id(){
  ${MINTER_HOME}/minter show_node_id
  pause
}

update_minter(){
  sudo chmod +x ${SCRIPTS_DIR}/minter-update &&
  sudo ${SCRIPTS_DIR}/minter-update &&
  sudo chmod -x ${SCRIPTS_DIR}/minter-update

  sleep 3

  sudo journalctl -u ${MINTER_SERVICE_NAME}  -n 200 | grep "software-version="

  pause
}

upgrade_minter(){
  sudo chmod +x ${SCRIPTS_DIR}/minter-upgrade &&
  sudo ${SCRIPTS_DIR}/minter-upgrade &&
  sudo chmod -x   ${SCRIPTS_DIR}/minter-upgrade

  pause
}

fail2ban_stats(){
  fail2ban-client status | sed -n 's/,//g;s/.*Jail list://p' | xargs -n1 fail2ban-client status
  pause
}

show_node_peers(){
  netstat -alpn | grep 26656 | grep ESTABLISHED
  pause
}


# function to display menus
show_menus() {
  clear
  echo "~~~~~~~~~~~~~~~~~~~~~"
  echo " M A I N - M E N U"
  echo "~~~~~~~~~~~~~~~~~~~~~"
  echo "1. Show minter journal"
  echo "2. Watch minter journal"
  echo "3. Stop Minter"
  echo "4. Restart Minter"
  echo "5. Update minter"
  echo "6. Upgrade minter"
  echo "7. Show Node Id"
  echo "8. Show Fail2Ban Stats"
  echo "9. Show Connected Peers"
  echo "0. Exit"
}
# read input from the keyboard and take a action
# invoke the one() when the user select 1 from the menu option.
# invoke the two() when the user select 2 from the menu option.
# Exit when user the user select 3 form the menu option.
read_options(){
  local choice
  read -p "Enter choice [ 0 - 9 ] " choice
  case $choice in
    1) show_journal ;;
    2) watch_journal ;;
    3) stop_minter ;;
    4) restart_minter ;;
    5) update_minter ;;
    6) upgrade_minter ;;
    7) show_node_id ;;
    8) fail2ban_stats ;;
    9) show_node_peers ;;
    0) exit 0;;
    *) echo -e "${RED}Error...${STD}" && sleep 2
  esac
}

# ----------------------------------------------
# Step #3: Trap CTRL+C, CTRL+Z and quit singles
# ----------------------------------------------
trap '' SIGINT SIGQUIT SIGTSTP

# -----------------------------------
# Step #4: Main logic - infinite loop
# ------------------------------------
while true
do
  show_menus
  read_options
done
