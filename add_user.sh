#!/bin/bash

#This script adds users to a system (intended for Jetstream VM) with the ability to ssh into the shell for collaborative use.

#A couple of notes about the script. Anything that has a # is not read by the computer.  Strings of #'s indicate a flexible point and a note below:
######1######) I have included a couple options in commented out lines - one at the top to allow for one or multiple users to be added.  Do not include ","s between the listed names!

######2######) If you are using Ubuntu, use the first block; if you are using CentOS, use the second.

######3######) If you add the people to the users group, they will likely have sudo - meaning root priviledges.  If you do not want this, you will have to make a separate group (e.g. "train") and add it to the allowable ssh groups in /etc/ssh/sshd_config.
#              If you only want to add people for use on an Rstudio server, etc. remove the usermod statement that is flagged.

declare -a names=("ncgas_admin")
#######1######## if you want to use multiple users, use the following format:
#declare -a names=("user1" "user2")

p=temporarypasswords4thewin!

for i in "${names[@]}"
do

#check if user exists
if grep -q $i /etc/passwd; 
	then : ; 
	#######2######if you are using Ubuntu, use these three lines and comment out the CentOS set:
	else adduser --disabled-password --gecos "" $i ; 
	     echo "$i:$p" | chpasswd ;
	     usermod -G users $i;          #######3######## This will give sudo access as well as ssh

	#######2######if you are on CentOS, use the below command instead, and comment out the above Ubuntu set:	
	#else adduser $i ;
	     #echo "$i:$p" | chpasswd ;
	     #usermod -G users $i;         #######3######## This will give sudo access as well as ssh
fi

#check if user home exists
if [ -d /home/$i ]; then : ; else mkdir -p /home/$i; fi

#force home owned by user and not root
chown $i /home/$i

#check if user home has correct permissions
if [ -r /home/$i ] && [ -w /home/$i ] && [ -x /home/$i ]; then : ; else chmod 755 /home/$i; fi

done

