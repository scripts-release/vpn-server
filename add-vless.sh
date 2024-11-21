if [ "$#" -ne 2 ]; then
  echo "Error: Expected 2 arguments, but got $#."
  exit 1
fi


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

user="$1"
CLIENT_EXISTS=$(grep -w $user /etc/xray/config.json | wc -l)
if [ "$CLIENT_EXISTS" -ne 0 ]; then
	echo ""
	echo "A client with the specified name was already created, please choose another name."
	echo ""
else
user_pass="$1:$2"
#read -p "Expired (days): " masaaktif
sed -i '/#vless$/a\#vls '"$user"'\
},{"id": "'""$user_pass""'","email": "'""$user""'"' /etc/xray/config.json
sed -i '/#vlessgrpc$/a\#vlsg '"$user"'\
},{"id": "'""$user_pass""'","email": "'""$user""'"' /etc/xray/config.json

echo "$user has been created" 

fi



