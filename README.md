Info
------------------
Набор инструментов для типовых процедур работы с Минтер нодой

Dependencies
------------------
* systemd service unit name "minter-node"
* minter home '/home/minter/' 
* fail2ban
* netstat

Run
------------------
```bash
git clone https://github.com/StakeHolderSpace/minter-tools.git
chmod 0744 ./minter-tools/menu.sh
sudo ./minter-tools/menu.sh


~~~~~~~~~~~~~~~~~~~~~
 M A I N - M E N U
~~~~~~~~~~~~~~~~~~~~~
1. Show minter journal
2. Stop Minter
3. Restart Minter
4. Show Node Id
5. Show Fail2Ban Stats
6. Show Connected Peers
7. Show P2P stats
0. Exit
Enter choice [ 0 - 7 ] 0

```

Notes
--------------

* Для того чтобы можно было управлять пирами и сидами через tendermint rpc , нужно в конфиге ноды выставить флаг "rpc.unsafe = true"
* ендпоинт \deal_peers не добавляет в адрес бук пиры которые в конфиге помечены как приватные ! [link](https://github
.com/tendermint/tendermint/blob/14e04f76067e519b8281b013b1037a6e46935123/p2p/switch.go#L471)
