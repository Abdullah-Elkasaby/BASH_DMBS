#!/bin/bash

function checkDatabaseExists 
{
    if [ -d ./databases/$1/ ]
    then
        return 1
    else 
        return 0
    fi
    # success
    

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

# get into the database directory
# MUST BE SOURCED
function connectDatabase 
{
    
    read -p "Enter Database name to connect to--> " dbName
    if  checkDatabaseExists $dbName
    then
        echo "ERROR! Database  Does Not Exists"
    else 
        cd ./databases/$dbName
        if checkLastCommand
        then 
            echo "Connected To Database $dbName Successfully"
        else 
            echo "ERROR Connecting To Database $dbName"
            
        fi
    fi
}

connectDatabase
