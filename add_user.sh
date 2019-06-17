#!/bin/bash

#This script adds users to a system (intended for Jetstream VM) with the ability to ssh into the shell for collaborative use.
#SEE www.ncgas.org/NCGAS_Blog.php/Adding%Users%to%Jetstream.php  up soon!
#http://ncgas.org/Blog_Posts/Installing%20conda%20packages%20locally.php

declare -a names=("ncgas_admin")

p=temporarypasswords4thewin!

for i in "${names[@]}"
do

#check if user exists
if grep -q $i /etc/passwd; 
	then : ; 
	else adduser --disabled-password --gecos "" $i ; 
	     echo "$i:$p" | chpasswd ;
	     usermod -G users $i;          ############### This will give sudo access as well as ssh
fi

#check if user home exists
if [ -d /home/$i ]; then : ; else mkdir -p /home/$i; fi

#force home owned by user and not root
chown $i /home/$i

#check if user home has correct permissions
if [ -r /home/$i ] && [ -w /home/$i ] && [ -x /home/$i ]; then : ; else chmod 755 /home/$i; fi

done

