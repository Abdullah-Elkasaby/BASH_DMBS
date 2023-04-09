#!/bin/bash




function isLastCmdTrue
{
    if [ $? ] 
        then 
            return 0
        else
            return 1
    fi
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

# typeset -i p=$(getPrimKeyFieldNum table)
# echo $(( p ))



# args $1 is table name, $2 is the value
function isNotDuplicatePk 
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

# isNotDuplicatePk table 55

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






# cut the line into column name and data type
# check if pk is set 
# if not find it in curr column name and edit the column name to be with out it

function insertIntoTable
{
    # database name is passed to the function
    local dbName=$1
    read -p "Enter Table Name--> " tableName
    local path="$dbName/$tableName"

    if getTable $path
    then
        :
    else

        return 1
    fi


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
        local colName=`cut -s -d  "|" -f $fieldIndex $path | cut -d ":" -f $nameIndex | head -1`
        local colType=`cut -s -d  "|" -f $fieldIndex $path | cut -d ":" -f $typeIndex | head -1`
        read -p "Enter Column:[$colName:$colType] Value--> " colValue
        
        #checking if the column is a prmary key 
        if [[ $colName =~ "(PK)" ]]
        then 
            
            if ! isNotDuplicatePk $path $colValue   
            then
                return 1
            fi

        fi
        
        

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
    if isLastCmdTrue
    then
        echo "Data Inserted Successfuly!"
        return 0
    else
        echo "ERROR in Inserting Data!"
    fi

}

insertIntoTable $1