
NUMBER_OF_CLIENTS=$(grep -c -E "^#vlsg " "/etc/xray/config.json")
	if [[ ${NUMBER_OF_CLIENTS} == '0' ]]; then
		echo ""
		echo "You have no existing clients!"
		exit 1
	fi

	clear

userd="$1"

if [ -z "$userd" ]; then
  echo "user is empty. Exiting..."
  exit 1
fi

user=$(grep -E "^#vlsg " "/etc/xray/config.json" | cut -d ' ' -f 2 | grep "$userd")
sed -i "/^#vlsg $user/,/^},{/d" /etc/xray/config.json
sed -i "/^#vls $user/,/^},{/d" /etc/xray/config.json
echo "$user has been deleted"
systemctl restart xray.service