#!/bin/bash

# Initialize active_users variable
active_users=""

# Extract usernames from active.sh if it exists
if [[ -f /etc/authorization/pandavpnunite/active.sh ]]; then
  active_users=$(awk '{print $2}' /etc/authorization/pandavpnunite/active.sh | sort -u)
fi

# Extract usernames from active2.sh if it exists
if [[ -f /etc/authorization/pandavpnunite/active2.sh ]]; then
  active_users+=" $(awk '{print $2}' /etc/authorization/pandavpnunite/active2.sh | sort -u)"
fi

if [[ -f /etc/authorization/pandavpnunite/active3.sh ]]; then
  active_users+=" $(awk '{print $2}' /etc/authorization/pandavpnunite/active3.sh | sort -u)"
fi

# Remove duplicates from active_users
active_users=$(echo "$active_users" | tr ' ' '\n' | sort -u)

# Get the list of current users with /sbin/nologin
current_users=$(awk -F: '$NF == "/sbin/nologin" {print $1}' /etc/passwd)

# Loop through current users and delete those not in active_users
for user in $current_users; do
  if ! echo "$active_users" | grep -q "^$user$"; then
    echo "Deleting user: $user"
    sudo userdel -r "$user" 2>/dev/null
  fi
done
