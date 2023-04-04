#!/bin/bash

function exitDatabase 
{
    cd ../../
}

function checkDatabaseExists 
{
    if [ -d ./databases/$1 ]
    then
        return 0
    else 
        return 1
    fi

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




function createDatabase 
{
    echo "Enter Database name to create: "
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
    echo "Enter Database name to drop: "
    read dbName
    if ! checkDatabaseExists $dbName
    then
        echo "ERROR! Database  Does Not Exist"
    else 
        rmdir databases/$dbName
        # check if cmd was a success
        if [ $? ] 
        then 
            echo "Database Dropped Successfully"
        else
            echo "Error Deleting $dbName" 
        fi
    fi
}


function connectDatabase 
{
    echo "Enter Database name to connect to: "
    read dbName
    if ! checkDatabaseExists $dbName
    then
        echo "ERROR! Database  Does Not Exists"
    else 
        cd ./databases/$dbName
        if checkLastCommand
        then 
            echo "Connected To Database Successfully"
            # tempPS1=$PS1
            # PS3="[$dbName]: "
            # read dd
        else 
            echo "ERROR Connecting To Database $dbName"
            
        fi
    fi
}

createDatabase
connectDatabase
exitDatabase
pwd
drobDatabase