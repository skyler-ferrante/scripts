#!/bin/bash

# To show output
# set -ex

# Set the password of user $USER to a random value
function set_random_password(){
	# Random number
	echo $USER':'$RANDOM | chpasswd
	
	# Or we can use a random word, (requires wamerican)
	# echo $1':'`shuf -n1 /usr/share/dict/words` | chpasswd
}

# If given a user: change password of user forever
# This could be used to increase the traffic of credential dumpers, 
# and potentially frustrate red team.
if [[ $1 ]];
then
	USER=$1
	
	# Check if user does not exist
	if ! id 1>/dev/null $USER;
	then
		read -p "Would you like to make a new user $USER? "
		if [[ $confirm == [yY] ]]; then
			exit 1;
		fi
		
		# Set everything to y
		yes | adduser $1 1>/dev/null
	fi
	
	while :
	do
		set_random_password
	done

# If not given a user, 
# change and lock passwords for all but current user and set shell to /sbin/nologin
else
	current_user=`whoami`
	USERS=`cat /etc/passwd \
		| grep -v $current_user \
	       	| awk -F: '{print $1}'`

	for USER in $USERS:
	do
		USER=`echo $USER | tr -d ':'`
		
		set_random_password
		
		usermod -L $USER
		usermod -s /sbin/nologin $USER
	done
fi
