#!/bin/bash
DATE=`date "+%Y%m%d"`
IO_HOUR=`date "+%H%M%S"`
IO_FILE="./LOG/$DATE/fileio_$IO_HOUR.LOG"

CFG_FILE="./CFG/lm.cfg"

function ioHelp
{
	echo "*****************************************************************"
	echo "*                            File I/O                           *"
	echo "*                                                               *"
	echo "*       1. Commands                                             *"
	echo "*        # READ ALL: Read lm.cfg                                *"
	echo "*        # READ PARAM: Read parameter's value                   *"
	echo "*           ex) READ MY_BRANCH                                  *"
	echo "*        # CHG PARAM VALUE: Change parameter's value            *"
	echo "*           ex) CHG LOADER_ARGS ODA02                           *"
	echo "*        # ADD PARAM VALUE: Add setted parameter and value      *"
	echo "*                           to the end of the file.             *"
	echo "*           ex) ADD PARAM01 ABC1                                *"
	echo "*                                                               *"
	echo "*       2. To end this program, please enter 'exit'.            *"
	echo "*****************************************************************"

}

function readFile
{
	if [ "${param[1]}" == "ALL" ]; then
		echo "# [READ] lm.cfg" | tee -a $IO_FILE
		cat $CFG_FILE
		
	elif [ ! "${param[1]}" ]; then
		echo "# [READ Error] Enter all parameters." | tee -a $IO_FILE
	else 
		if [ `awk -c '/^'${param[1]}'=/' $CFG_FILE` ]; then
			readLine=`sed -n '/^'${param[1]}'=/p' $CFG_FILE`
			echo "# [READ] $readLine" | tee -a $IO_FILE
		else
			echo "# [READ Error] The parameter does not exist." | tee -a $IO_FILE
		fi
	fi
}

function chgFile
{
	if [ ! "${param[2]}" ]; then
		echo "# [CHG Error] Enter all parameters." | tee -a $IO_FILE
	elif [ `awk -c '/^'${param[1]}'=/' $CFG_FILE` ]; then
		lineNum=`cat $CFG_FILE | grep -n "^${param[1]}=" | awk -F: '{print $1}'`
		chgLine="${param[1]}=${param[2]}"
		echo "# [CHG] $chgLine" | tee -a $IO_FILE

		sed -i "${lineNum}s/.*/$chgLine/g" $CFG_FILE
	else
		echo "# [CHG Error] The parameter does not exist." | tee -a $IO_FILE
	fi
}

function addFile
{
	if [ ! "${param[2]}" ]; then
		echo "# [ADD Error] Enter all parameters." | tee -a $IO_FILE
	elif [ ! `echo ${param[1]} | tr -d "[:digit:]"` ]; then
		echo "# [ADD Error] Enter the valid parameter name." | tee -a $IO_FILE
	elif [[ ! `echo ${param[1]} | tr -d "[:alnum:]"` ]] &&
	     [[ ! `awk -c '/^'${param[1]}'=/' $CFG_FILE` ]] ; then
		newLine="${param[1]}=${param[2]}"
		echo "# [ADD] $newLine" | tee -a $IO_FILE

		echo  $newLine >> $CFG_FILE
	else
		echo "# [ADD Error] Enter the valid parameter name." |tee -a $IO_FILE
	fi
}

ioHelp;

while true; do
	echo -n "# Command: "
	read -a  param

	case ${param[0]} in
		'READ') readFile;
			;;
		'CHG') chgFile;
			;;
		'ADD') addFile;
			;;
		'exit') exit;
			;;
		*) echo "# [Error] Enter the valid parameters." | tee -a $IO_FILE
		   ioHelp
		   ;;
	esac
done
