#!/bin/bash
DATE=`date "+%Y%m%d"`
DB_HOUR=`date "+%H%M%S"`
DB_FILE="./LOG/$DATE/querydb_$DB_HOUR.LOG"

function dbHelp
{
	echo "********************************************************"
	echo "*                      DB Query                        *"
	echo "*                                                      *"
	echo "*      1. Query                                        *"
	echo "*       # SELECT DBName TableName LimitNum             *"
	echo "*        ex)SELECT zonedb user 3                       *"
	echo "*       # UPDATE DBName TableName FieldName ChgName    *"
	echo "*        ex)UPDATE zonedb user onoff using             *"
	echo "*                                                      *"
	echo "*      2. To end this program, please enter 'exit'.    *"
	echo "********************************************************"
}

function upperCase
{
	echo $* | tr "[a-z]" "[A-Z]"
}

function selectDB
{
	if [ ! "${param[3]}" ]; then
		echo "# [SELECT Error] Enter all parameters." | tee -a $DB_FILE
	else 
		ifExists=$(exec mysql -uroot -pimEhfl25! ${param[1]} -N -s -e "select count(*) from ${param[2]}")

		if [ $ifExists ]; then
			mysql -uroot -pimEhfl25! ${param[1]} -t <<EOSQL
			select * from ${param[2]} limit ${param[3]}
EOSQL
			echo "# [SELECT] ${param[1]} ${param[2]} ${param[3]}" >> $DB_FILE
		else
			echo "# [SELECT Error] Enter valid parameters." | tee -a $DB_FILE
		fi
	fi
}

function updateDB
{
	if [ ! "${param[4]}" ]; then
		echo "# [UPDATE Error] Enter all parameters." | tee -a $DB_FILE
	else
		ifExists=$(exec mysql -uroot -pimEhfl25! ${param[1]} -N -s -e "select ${param[3]} from ${param[2]} limit 1")
		echo "value: $ifExists"

		if [ $ifExists ]; then
			mysql -uroot -pimEhfl25! ${param[1]} -t <<EOSQL
			update ${param[2]} set ${param[3]}="${param[4]}";
			select * from ${param[2]};
EOSQL
			echo "# [UPDATE] ${param[1]} ${param[2]} ${param[3]} ${param[4]}" >> $DB_FILE
		else 
			echo "# [UPDATE Error] Enter valid parameters or check the records in ${param[2]}." | tee -a $DB_FILE
		fi
	fi
}

dbHelp;

while true; do
	echo -n "# query > "
	read -a param

	param[0]=$(upperCase ${param[0]})

	case ${param[0]} in
		'SELECT') selectDB;
				;;
		'UPDATE') updateDB;
				;;
		'EXIT') exit;
			;;
		*) echo "# [Error] Enter the valid parameters." | tee -a $DB_FILE
		   dbHelp;
		   ;;
	esac
done
