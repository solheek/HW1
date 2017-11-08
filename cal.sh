#!/bin/bash
DATE=`date "+%Y%m%d"`
CAL_HOUR=`date "+%H%M%S"`
CAL_FILE="./LOG/$DATE/cal_$CAL_HOUR.LOG"

function calHelp 
{
	echo "*****************************"
	echo "*        Calculator         *"
	echo "*                           *"
	echo "*  1. Enter the expression  *"
	echo "*         ex) 1+5           *"
	echo "*             3*7           *"
	echo "*  2. To end this program,  *"
	echo "*     enter 'exit'.         *"  
	echo "*****************************"
}

calHelp;

while true; do
	read -p "# Expression: " inputExp
	
	if [[ `echo $inputExp | tr -d "[:digit:] [+] [-] [*] [/]"` ]] || 
	   [[ "$inputExp" == "" ]] && [[ ! "$inputExp" == "exit" ]]; then
		echo "# [Error] Enter the valid expression." | tee -a $CAL_FILE
		calHelp;
	elif [ "$inputExp" == "exit" ]; then
		exit;
	else
		result=$(($inputExp))
		echo "# $inputExp=$result" | tee -a $CAL_FILE
	fi
done
