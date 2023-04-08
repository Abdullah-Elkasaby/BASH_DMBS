#!/bin/bash

# DB NAME MUST BE SUBMITTED WHEN RUNNING THIS FILE

function listTables
{
    local dbName=$1
    local counter=1
    echo "Database[$dbName] has: "
    for tableName in ` ls $dbName `
    do 
        echo "Table[$(( counter++ ))] --> $tableName "
    done
}

function selectTable 
{

    read -p "Enter Table Name--> " tableName
    path="$1/$tableName"
    if [[ -f $path ]] && ! [[ -z $path ]]
    then
        
        # -t to make a table of it. -s for the seprator
        column -t -s "|" $path
        return 0
    else
        echo "Table $tableName DOES NOT EXIST!"
        return 1
    fi

}



function tableMenu 
{
    echo "_____________________________________"
    echo
    local dbName=$1
    PS3="Connected to [$dbName]--> "
    options=("List Tables" "Select a Table" "Create Table" "Insert into Table" "Update Table" "Delete from Table" "Drop Table")
    select opt in "${options[@]}" 
    do
        case $REPLY in 
            1)  clear
                listTables $dbName
                tableMenu $dbName
                ;;

            2)  clear
                selectTable $dbName 
                tableMenu $dbName
                ;;
            3)  clear
                source create_table.sh $dbName
                tableMenu $dbName
                ;;
            4)  clear
                source insert_into_table.sh $dbName
                tableMenu $dbName
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
# echo $1
tableMenu $1