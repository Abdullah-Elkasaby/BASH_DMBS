#!/bin/bash

# DB NAME MUST BE SUBMITTED WHEN RUNNING THIS FILE

function listTables
{
    dbName=$1
    counter=1

    echo "Database[$dbName] has: "
    for tableName in ` ls ./databases/$dbName/ `
    do 
        echo "Table[$(( counter++ ))] --> $tableName "
    done
}

function selectTable 
{
    read -p "Enter Table Name--> " tableName
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



function tableMenu 
{
    dbName=$1
    PS3="Connected to [$dbName]--> "
    options=("List Tables" "Select a Table" "Create Table" "Insert into Table" "Update Table" "Delete from Table" "Drop Table")
    select opt in "${options[@]}" 
    do
        case $REPLY in 
            1)  listTables $dbName
                ;;
            2)  selectTable $dbName 
                ;;
            3)  clear
                source create_table.sh $dbName
                tableMenu $dbName
                ;;
            4) source insert_into_table.sh "./databases/$dbName"
                ;;
            5) echo updateTable
                ;;
            6) echo DeleteFromTable
                ;;
            7) echo dropTable
                ;;
            
            *) echo CHOICE DOES NOT EXIST!
                ;; 
        esac
            
    done 
}


# $1 is the database names passed when running the file
tableMenu $1