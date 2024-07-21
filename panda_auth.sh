#!/bin/bash
cat <<EOM > /etc/openvpn/login/test_config.sh
HOST='185.61.137.171'
USER='daddyjoh_pandavpn_unity'
PASS='pandavpn_unity'
DBNAME='daddyjoh_pandavpn_unity'
EOM

chmod 755 /etc/openvpn/login/test_config.sh

cp /etc/authorization/pandavpnunite/connection.php /etc/authorization/pandavpnunite/connection2.php
sed -i "s|login/config.sh|login/test_config.sh|g" /etc/authorization/pandavpnunite/connection2.php
sed -i "s|/etc/authorization/pandavpnunite/active.sh|/etc/authorization/pandavpnunite/active2.sh|g" /etc/authorization/pandavpnunite/connection2.php
sed -i "s|/etc/authorization/pandavpnunite/uuid.sh|/etc/authorization/pandavpnunite/uuid2.sh|g" /etc/authorization/pandavpnunite/connection2.php
sed -i "s|/etc/authorization/pandavpnunite/not-active.sh|/etc/authorization/pandavpnunite/not-active2.sh|g" /etc/authorization/pandavpnunite/connection2.php


/usr/bin/php /etc/authorization/pandavpnunite/connection2.php
/bin/bash /etc/authorization/pandavpnunite/active.sh

systemctl restart openvpn@server2.service
systemctl restart openvpn@server.service

