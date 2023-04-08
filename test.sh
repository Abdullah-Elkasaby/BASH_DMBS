#!/bin/bash




function getPrimKeyFieldNum
{
    local tableName=$1
    # -v sets a var 
    local currField=` awk -v RS='|' '/PK/ {print NR}'  $tableName `
    echo $currField
}

# typeset -i p=$(getPrimKeyFieldNum table)
# echo $(( p ))


function checkDuplicateExist 
{
    local tableName=$1
    local valueToCheck=$2
    pkFeildNum=$(getPrimKeyFieldNum $tableName)
    # delete the first line containing the schema then get the pk column
    local pkColValues=`sed '1d' $tableName | cut -d "|" -f $pkFeildNum `
    # echo $pkColValues
    for currValue in $pkColValues
    do 
        # echo $currValue -- $valueToCheck
        if [ $currValue = $valueToCheck ]
        then
            echo "ERROR! Duplicate Primary Key!"
            return 1
        fi
    done
    return 0
}

checkDuplicateExist table 55