#!/bin/bash

ID='Solhee25'
PW='?1025?'
DATE=`date "+%Y%m%d"`
LOGIN_HOUR=`date "+%H%M%S"`
LOGIN_FILE="./LOG/$DATE/login_$LOGIN_HOUR.LOG"

function loginHelp
{
	echo "*******************************************************"
	echo "*               Welcome to this program               *" 
	echo "*                                                     *"
	echo "*    # Login information                              *"
	echo "*    -> ID : do not include special characters.       *"
	echo "*    -> PW : include 1 or more special characters.    *"
	echo "*                                                     *"  
	echo "*       To end this program, please enter 'exit'      *"  
	echo "*******************************************************"
}

function progHelp
{
	echo "*******************************************************"
	echo "*       Now, You can use the follow functions.        *"
	echo "*       Enter the number which you want to use.       *"
	echo "*                                                     *"
	echo "*        1. Calculator                                *"
	echo "*        2. File I/O                                  *"
	echo "*        3. Perform DB query                          *"
	echo "*        4. Process linux command                     *"
	echo "*        5. Display substitution of df -k output      *"
	echo "*                                                     *"
	echo "*       To end this program, please enter 'exit'      *"
	echo "*******************************************************"
}

if [ ! -d ./LOG/$DATE ]; then
	echo "# New log directory is created."
	mkdir  ./LOG/$DATE
fi

loginHelp;

################ Login step ################## 

while true; do
	read -p "# ID: " inputID

	if [[ `echo $inputID | tr -d "[:alnum:]"` ]] || [[ "$inputID" == "" ]]; then
		echo "# [Error] ID doesn't include special characters." | tee -a $LOGIN_FILE
		loginHelp;
		continue;
	elif [ "$inputID" == "exit" ]; then
		exit;
	fi


	read -p "# PW: " inputPW

	if [ "$inputPW" == "exit" ]; then
		exit;
	elif [ `echo $inputPW | tr -d "[:alnum:]"` ]; then
		if [[ $inputID == $ID ]] && [[ $inputPW == $PW ]]; then
			echo "# Login successfully !!" | tee -a $LOGIN_FILE
			break;
		else
			echo "# [Error] Incorrect ID or PW. " | tee -a $LOGIN_FILE
			loginHelp;
		fi
	else 
		echo "# [Error] PW includes special characters." | tee -a $LOGIN_FILE
		loginHelp;
	fi
done


################ function selection step ###############
progHelp;

while true; do
	read -p "# select: " inputNum

	case $inputNum in
		1)	./cal.sh
			exit;
			;;
		2)	./fileIO.sh
			exit;
			;;
		3)	./queryDB.sh
			exit;
			;;
		4)	./topCo.sh
			exit;
			;;
		5)	./subOut.sh
			progHelp;
			;;
		'exit')
			exit;
			;;
		*)	progHelp;
			;;
	esac
done
