#!/bin/bash



function listTables
{
    ls -p | grep -v /
}





function checkLastCommand
{
    if [ $? ] 
        then 
            return 0
        else
            return 1
    fi
}




function exitDatabase 
{
    cd ../../
}


function isInteger
{   

    intPattern="^[0-9]+$"
    if [[ $1 =~ $intPattern ]]
    then
        return 0
    else 
        return 1
    fi
}






function isValidString
{
    if [[ $1 =~ ^[a-zA-Z0-9]+$ ]]
    then
        return 0
    else
        return 1
    fi
}




function getPrimKeyFieldNum
{
    local tableName=$1
    # -v sets a var 
    local currField=` awk -v RS='|' '/PK/ {print NR}'  $tableName `
    echo $currField
}



# database name is passed to function 
function getTable 
{
    local tableName=$1
    
    # checking if it's in the database which we are connected to
    if [[ -f $tableName ]] && ! [[ -z $tableName ]]
    then
        echo "Table Selected!"
        return 0
    else
        echo "Table DOES NOT EXIST!"
        return 1
    fi

}





typeset -i p=$(getPrimKeyFieldNum table)
echo $(( p ))

# cut the line into column name and data type
# check if pk is set 
# if not find it in curr column name and edit the column name to be with out it

function insertIntoTable
{
    # database name is passed to the function
    dbName=$1
    read -p "Enter Table Name--> " tableName

    if getTable "$dbName/$tableName"
    then
        :
    else

        return 1
    fi

    path="$dbName/$tableName"

    # tr is the translate or delete cmd it -c for complement and d for delete 
    typeset -i colsNum=` head -1 $path | tr -cd '|' | wc -c `
    fieldIndex=1
    nameIndex=1
    typeIndex=2
    counter=0

    recordValues=""
    
    while [[ counter -lt colsNum ]]
    do
    
        # -s not to list anything not delimited 
        colName=`cut -s -d  "|" -f $fieldIndex $path | cut -d ":" -f $nameIndex | head -1`
        colType=`cut -s -d  "|" -f $fieldIndex $path | cut -d ":" -f $typeIndex | head -1`
        read -p "Enter Column:[$colName:$colType] Value--> " colValue

        if [ $colType = "int" ]
        then
            while ! isInteger $colValue
            do 
                # using \n with doulbe qoutes doesnot work 
                read -p "INVALID VALUE! `echo $'\n '` Enter Column:[$colName:$colType] Value--> " colValue        
            done
        else
            while ! isValidString $colValue
            do 
                read -p "INVALID VALUE! `echo $'\n '` Enter Column:[$colName:$colType] Value--> " colValue       
            done
            # check for string not containg any special characters
        fi
        # TODO: test input and its datatype
        recordValues+="$colValue|"
        # then check the recordValues
        # Finally Write them to file

        (( fieldIndex++ ))
        (( counter++ ))
    done
    

    # append new line and the next record to the table
    printf "\n$recordValues" >> $path

}

insertIntoTable $1