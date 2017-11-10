#!/bin/bash
DATE=`date "+%Y%m%d"`
TOP_HOUR=`date "+%H%M%S"`
TOP_FILE="./LOG/$DATE/topco_$TOP_HOUR.LOG"

function coHelp
{
	echo "*********************************************"
	echo "*             Processing command            *"
	echo "*                                           *"
	echo "*   You can check the process task lists.   *"
	echo "*                                           *"
	echo "*    1. Command                             *"
	echo "*     # TIME_INTERVAL COUNT                 *"
	echo "*      ex) 10 5                             *"
	echo "*    2. To end this program, enter 'exit'   *"
	echo "*********************************************"
}

coHelp;

while true; do
	echo -n "# VIEW_RES: "
	read -a param

	if [ "${param[0]}" == "exit" ]; then
		exit;
	elif [ ! "${param[1]}" ]; then
		echo "# [Error] Enter all parameters." | tee -a $TOP_FILE
		coHelp;
	elif [ ! `echo ${param[0]}${param[1]} | tr -d "[:digit:]"` ]; then
		top -d ${param[0]} -n ${param[1]}
		echo "# top -d ${param[0]} -n ${param[1]}" >> $TOP_FILE
	else
		echo "# [Error] Enter valid parameters." | tee -a $TOP_FILE
		coHelp;
	fi
done
