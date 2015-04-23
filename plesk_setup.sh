#/bin/bash

# This script is build to install plesk on Ubuntu and Debian for lazy people who do not
# want to do it step by step.

# Text colors
# yellow = echo -e "\x1B[01;93m yellow text \x1B[0m"
# red = echo -e "\x1B[31m red text \x1B[0m"

# Variables
ip=`ifconfig eth0 | grep "inet addr" | awk -F: '{print $2}' | awk '{print $1}'`

# The most important part: ARE YOU ROOT?

if (( $EUID != 0 )); then
	echo ""
	echo -e "\x1B[31m Looks like you are not logged in as Root. 
Please run as root or the script cannot be used!\x1B[0m"
	echo ""
   exit
fi

# Performing update && upgrade and autoremove crap
echo -e "\x1B[01;93m At frist you need to perform an update && upgrade.\x1B[0m"
echo " "
read -p "\x1B[01;93m Press any Key to perform an update && upgrade... \x1B[0m" -n1 -s
		apt-get update && apt-get upgrade -y
echo -e "\x1B[01;93m In case you did not remove old crap I will perform an "autoremove" right now.\x1B[0m"
echo ""
read -p "Press any key to continue..." -n1 -s
	apt-get autoremove
echo -e "\x1B[01;93m Done.\x1B[0m"


# Making sure php5 is installed
echo -e "\x1B[01;93m Installing PHP5..\x1B[0m"
	apt-get install php5 -y
echo ""

# Removing AppArmor so install wont fail
echo -e "\x1B[01;93m Removing AppArmor to get red of problems with the install..\x1B[0m"
	apt-get remove apparmor -y
echo ""

# Getting the autoinstaller
echo -e "\x1B[01;93m Downloding the plesk autoinstaller..\x1B[0m"
wget -O plesk-installer.sh http://autoinstall.plesk.com/plesk-installer
echo ""

# Making the installer executable
echo -e "\x1B[01;93m Fixing permissions..\x1B[0m"
chmod +x plesk-installer.sh
echo ""

# Execute the installer
echo -e "\x1B[01;93m Running the plesk install script..\x1B[0m"
./plesk-installer.sh
echo -e "\x1B[01;93m Installation of Plesk is done.\x1B[0m"
echo ""

# Showing generated password
password=`/usr/local/psa/bin/admin --show-password`
echo -e "\x1B[01;93m Your plesk admin password is:\x1B[0m $password"

echo -e "
\x1B[01;93m Congratulations, you made it. Plesk is now installed on your system.
 
 You are now able to login into the Plesk Panel at:\x1B[0m https://$ip:8443/
 
\x1B[01;93m Please use the username:\x1B[0m admin

\x1B[01;93m Your password is:\x1B[0m $password"# Print the finished message

# Information on how to change password
echo ""
echo -e '\x1B[01;93m Please change your password using "/usr/local/psa/bin/init_conf -u -passwd YourNewPAssword"\x1B[0m'
echo ""
echo "Thank you and enjoy plesk."

exit
