#!/bin/bash

#This script adds users to a system (intended for Jetstream VM) with the ability to ssh into the shell for collaborative use.
#If you only want to add people for use on an Rstudio server, etc. remove the usermod statement that is flagged.

declare -a names=("ncgas_admin")

#if more than one the syntax is as below:
#declare -a names=("user1" "user2") 

p=temporarypasswords4thewin!

for i in "${names[@]}"
do

#check if user exists
if grep -q $i /etc/passwd; 
	then : ; 
	else adduser --disabled-password --gecos "" $i ; 
	     echo "$i:$p" | chpasswd ;
	     usermod -G users $i;	#DO THIS ONLY IF YOU WANT THEM TO BE ABLE TO SSH AND HAVE SUDO!!
fi

#check if user home exists
if [ -d /home/$i ]; then : ; else mkdir -p /home/$i; fi

#force home owned by user and not root
chown $i /home/$i

#check if user home has correct permissions
if [ -r /home/$i ] && [ -w /home/$i ] && [ -x /home/$i ]; then : ; else chmod 755 /home/$i; fi
done
