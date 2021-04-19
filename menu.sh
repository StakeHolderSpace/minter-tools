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
  ${MINTER_HOME}/bin/minter show_node_id
  pause
}


fail2ban_stats(){
  fail2ban-client status | sed -n 's/,//g;s/.*Jail list://p' | xargs -n1 fail2ban-client status
  pause
}

show_node_peers(){
  #netstat -alpn | grep "/minter" | grep ESTABLISHED

  curl -s 'http://localhost:26657/net_info' | \
  python3 -c "import sys, json;
  peers = [];
  peers_info = json.load(sys.stdin)
  for peer in peers_info['result']['peers']:
    node_info = peer['node_info']
    remote_ip = peer['remote_ip']
    id = node_info['id']
    moniker = node_info['moniker']
    listen_addr = node_info['listen_addr']
    p2p_port = listen_addr.split(':')[-1]
    peers.append('%s@%s:%s # %s' % (id, remote_ip, p2p_port, moniker))

  print('\n\r'.join('{0}'.format(w) for w in peers))
  print('='*50)
  print(len(peers))
  "
  pause
}

show_iptables_stats(){
 sudo iptables -L ufw-minter-p2p -n -v
 pause
}

# function to display menus
show_menus() {
  clear
  echo "~~~~~~~~~~~~~~~~~~~~~"
  echo " M A I N - M E N U"
  echo "~~~~~~~~~~~~~~~~~~~~~"
  echo "1. Show minter journal"
  echo "2. Stop Minter"
  echo "3. Restart Minter"
  echo "4. Show Node Id"
  echo "5. Show Fail2Ban Stats"
  echo "6. Show Connected Peers"
  echo "7. Show P2P stats"
  echo "0. Exit"
}
# read input from the keyboard and take a action
# invoke the one() when the user select 1 from the menu option.
# invoke the two() when the user select 2 from the menu option.
# Exit when user the user select 3 form the menu option.
read_options(){
  local choice
  read -p "Enter choice [ 0 - 10 ] " choice
  case $choice in
    1) show_journal ;;
    2) stop_minter ;;
    3) restart_minter ;;
    4) show_node_id ;;
    5) fail2ban_stats ;;
    6) show_node_peers ;;
    7) show_iptables_stats ;;
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
