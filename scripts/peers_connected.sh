#!/usr/bin/env bash

# Get formatted list of node connected peers

  curl -s 'http://localhost:36657/net_info' | \
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

# curl -s 'http://localhost:26657/dial_peers?persistent=false&peers=\["429fcf25974313b95673f58d77eacdd434402665@10.11.12.13:26656"\]'
