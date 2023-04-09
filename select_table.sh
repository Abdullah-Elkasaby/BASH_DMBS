#!/bin/bash


# The user should be in the database he wants, so select database beforhand

# Database name is the first argument
# table name is the second argument
function selectTable 
{
    dbName=$1
    tableName=$2
    # checking if it's in the database which we are connected to
    if [[ -f $(pwd)/$tableName ]] && ! [[ -z $tableName ]]
    then
        echo "$tableName Selected!"
        return 0
    else
        echo "Table $tableName DOES NOT EXIST!"
        return 1
    fi

}

selectTable $1