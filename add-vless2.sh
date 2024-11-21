BIBlack='\033[1;90m'      # Black
BIRed='\033[1;91m'        # Red
BIGreen='\033[1;92m'      # Green
BIYellow='\033[1;93m'     # Yellow
BIBlue='\033[1;94m'       # Blue
BIPurple='\033[1;95m'     # Purple
BICyan='\033[1;96m'       # Cyan
BIWhite='\033[1;97m'      # White
UWhite='\033[4;37m'       # White
On_IPurple='\033[0;105m'  #
On_IRed='\033[0;101m'
IBlack='\033[0;90m'       # Black
IRed='\033[0;91m'         # Red
IGreen='\033[0;92m'       # Green
IYellow='\033[0;93m'      # Yellow
IBlue='\033[0;94m'        # Blue
IPurple='\033[0;95m'      # Purple
ICyan='\033[0;96m'        # Cyan
IWhite='\033[0;97m'       # White
NC='\e[0m'

# // Export Color & Information
export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[0;33m'
export BLUE='\033[0;34m'
export PURPLE='\033[0;35m'
export CYAN='\033[0;36m'
export LIGHT='\033[0;37m'
export NC='\033[0m'

# // Export Banner Status Information
export EROR="[${RED} EROR ${NC}]"
export INFO="[${YELLOW} INFO ${NC}]"
export OKEY="[${GREEN} OKEY ${NC}]"
export PENDING="[${YELLOW} PENDING ${NC}]"
export SEND="[${YELLOW} SEND ${NC}]"
export RECEIVE="[${YELLOW} RECEIVE ${NC}]"

# // Export Align
export BOLD="\e[1m"
export WARNING="${RED}\e[5m"
export UNDERLINE="\e[4m"

# // Exporting URL Host
export Server_URL="raw.githubusercontent.com/NevermoreSSH/Blueblue/main/test"
export Server1_URL="raw.githubusercontent.com/NevermoreSSH/Blueblue/main/limit"
export Server_Port="443"
export Server_IP="underfined"
export Script_Mode="Stable"
export Auther=".geovpn"

# // Root Checking
if [ "${EUID}" -ne 0 ]; then
		echo -e "${EROR} Please Run This Script As Root User !"
		exit 1
fi

# // Exporting IP Address
export IP=$( curl -s https://ipinfo.io/ip/ )

# // Exporting Network Interface
export NETWORK_IFACE="$(ip route show to default | awk '{print $5}')"


clear
source /var/lib/scrz-prem/ipvps.conf
if [[ "$IP" = "" ]]; then
domain=$(cat /etc/xray/domain)
else
domain=$IP
fi
tls="$(cat ~/log-install.txt | grep -w "Vless TLS" | cut -d: -f2|sed 's/ //g')"
none="$(cat ~/log-install.txt | grep -w "Vless None TLS" | cut -d: -f2|sed 's/ //g')"
		#read -rp "User: " -e user
user="$1"
CLIENT_EXISTS=$(grep -w $user /etc/xray/config.json | wc -l)
if [ "$CLIENT_EXISTS" -ne 0 ]; then
	echo ""
	echo "A client with the specified name was already created, please choose another name."
	echo ""
else
uuid=$(cat /proc/sys/kernel/random/uuid)
#read -p "Expired (days): " masaaktif
masaaktif="$2"
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
sed -i '/#vless$/a\#vls '"$user $exp"'\
},{"id": "'""$uuid""'","email": "'""$user""'"' /etc/xray/config.json
sed -i '/#vlessgrpc$/a\#vlsg '"$user $exp"'\
},{"id": "'""$uuid""'","email": "'""$user""'"' /etc/xray/config.json
cat > /home/vps/public_html/vless-$user.txt <<-END

====================================================================
             P R O J E C T  O F  N E V E R M O R E S S H
                       [Freedom Internet]
====================================================================
        https://github.com/NevermoreSSH/Blueblue
====================================================================
              Format Vless WS/GRPC
====================================================================

_______________________________________________________
              Link Vless Account
_______________________________________________________
Link TLS : vless://${uuid}@${domain}:443?type=ws&encryption=none&security=tls&host=${domain}&path=/vless&allowInsecure=1&sni=${domain}#XRAY_VLESS_TLS_${user}
_______________________________________________________
Link none TLS : vless://${uuid}@${domain}:80?type=ws&encryption=none&security=none&host=${domain}&path=/vless#XRAY_VLESS_NTLS_${user}
_______________________________________________________
Link GRPC : vless://${uuid}@${domain}:$tls?mode=gun&security=tls&encryption=none&type=grpc&serviceName=vless-grpc&sni=bug.com#VLESS_GRPC_${user}
_______________________________________________________
Expired On : $exp
_______________________________________________________

END
vlesslink1="vless://${uuid}@${domain}:443?type=ws&encryption=none&security=tls&host=${domain}&path=/vless&allowInsecure=1&sni=${domain}#XRAY_VLESS_TLS_${user}"
vlesslink2="vless://${uuid}@${domain}:80?type=ws&encryption=none&security=none&host=${domain}&path=/vless#XRAY_VLESS_NTLS_${user}"
vlesslink3="vless://${uuid}@${domain}:$tls?mode=gun&security=tls&encryption=none&type=grpc&serviceName=vless-grpc&sni=${domain}#VLESS_GRPC_${user}"
systemctl restart xray
echo ""
echo "Remarks : ${user}"
echo "Domain : ${domain}"
echo "port TLS : $tls"
echo "port none TLS : $none"
echo "id : ${uuid}"
echo "Network : ws/grpc"
echo "Encryption : none"
echo "Path : /vless"
echo "Path : vless-grpc"
echo "Expired On : $exp"
#read -n 1 -s -r -p "Press any key to back on menu"

fi



