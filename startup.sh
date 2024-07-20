#!/bin/bash

for session in $(screen -ls | grep Detached | grep -v installer | cut -d. -f1); do screen -S "${session}" -X quit; done
screen -dmS socks python /etc/socks.py 90
screen -dmS websocket python /usr/local/sbin/websocket.py 8081
screen -dmS socksovpn python /usr/local/sbin/socksovpn.py 80
screen -dmS proxy python /usr/local/sbin/proxy.py 8010
screen -dmS udpvpn /usr/bin/badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 1000 --max-connections-for-client 3
screen -dmS slowdns-server ~/dnstt/dnstt-server/dnstt-server -udp :PORT_DNSTT_SERVER -privkey-file ~/dnstt/dnstt-server/server.key $(cat /root/ns.txt) 127.0.0.1:22
screen -dmS slowdns-client ~/dnstt/dnstt-client/dnstt-client -dot 1.1.1.1:853 -pubkey-file ~/dnstt/dnstt-client/server.pub $(cat /root/ns.txt) 127.0.0.1:PORT_DNSTT_SSH_CLIENT
screen -dmS webinfo php -S 0.0.0.0:5623 -t /root/.web/