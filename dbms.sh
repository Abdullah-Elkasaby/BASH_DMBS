#!/bin/bash

function checkDatabaseExists 
{
    if [ -d ./databases/$1 ]
    then
        return 0
    else 
        return 1
    fi

}




function createDatabase 
{
    echo "Enter Database Name: "
    read dbName
    #Valdiate Name Missing
    if checkDatabaseExists $dbName
    then
        echo "ERROR! Database  Name Already Exists"
    else 
        mkdir ./databases/$dbName
        if [ $? ] 
        then 
            echo "Database Created Successfuly!" 
        else
            echo "Error Creating $dbName" 
        fi
        
    fi 

}

function drobDatabase 
{
    echo "Enter Database Name: "
    read dbName
    if ! checkDatabaseExists $dbName
    then
        echo "ERROR! Database  Does Not Exists"
    else 
        rmdir databases/$dbName
        # check if cmd was a success
        if [ $? ] 
        then 
            echo "Databased Dropped Successfully"
        else
            echo "Error Deleting $dbName" 
        fi
    fi
}

createDatabase
drobDatabase