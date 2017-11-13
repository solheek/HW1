#!/bin/bash
DATE=`date "+%Y%m%d"`
SUB_HOUR=`date "+%H%M%S"`
SUB_FILE="./LOG/$DATE/subout_$SUB_HOUR.LOG"

function subHelp
{
	echo "*************************************************"
	echo "*               Substitute output               *"
	echo "*                                               *"
	echo "*   You can check the substituted disc status.  *"
	echo "*   (The original command was df -k)            *"
	echo "*************************************************"
}

subHelp;
echo "# df -k is substituted to df -h." | tee -a $SUB_FILE
df -k | gawk -f trans.awk;

