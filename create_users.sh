#!/bin/bash

#Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
echo "Error: This script must be run as root."
exit 1
fi

#Loop through all usernames passed to the script
for username in "$@"
do 

#Save existing users before creating new ones
existing_users=$(cut -d: -f1 /etc/passwd)

#Create the user and their home directory
useradd -m "$username"

#Create folders in the users home directory
mkdir -p "/home/$username/Documents"
mkdir -p "/home/$username/Downloads"
mkdir -p "/home/$username/Work"

#Set permissions so only the owner has access to their files
chmod 700 "/home/$username/Documents"
chmod 700 "/home/$username/Downloads"
chmod 700 "/home/$username/Work"

#Create welcome file
echo "Välkommen $username" > "/home/$username/welcome.txt"

#Add more users
cut -d: -f1 /etc/passwd | grep -v "^$username$" >> "/home/$username/welcome.txt"

#Make the user the owner of their home directory and files
chown -R "$username:$username" "/home/$username"
done