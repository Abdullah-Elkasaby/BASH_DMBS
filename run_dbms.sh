#!/bin/bash

function exitDatabase 
{
    cd ../../
}

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


# Function to validate database name input
function validate_dbname() {

    dbname=$1
    # Check for empty name
    if [[ $dbname = "" ]]; then
        echo "Error: database name is not set, please enter database name"
        return 1
    fi

    # Check for invalid characters
    if [[ $dbname =~ [^a-zA-Z0-9_] ]]; then
        echo "Error: invalid database name. Database names can only contain letters, digits, and underscores."
        return 1
    fi

   
    # Check for leading number or special character
    if [[ $dbname =~ ^[0-9] || $dbname =~ ^[^a-zA-Z0-9_] || $dbname =~ ^[\W_]+ ]]; then
        echo "Error: invalid database name. Database names cannot start with a number or special character."
        return 1
    fi

   
    # Validation successful
    return 0
}


function createDatabase 
{
    echo "Enter Database name to create: "
    read dbName

    #Valdiate Name Missing
    if ! validate_dbname $dbName
    then
        return 1
    elif checkDatabaseExists 
        then
        echo "ERROR! Database  Name Already Exists"
        return 1
    fi 

    mkdir ./databases/$dbName
    if ! checkLastCommand
    then 
        echo "Error Creating $dbName" 
        return 1
    fi


    echo "Database Created Successfuly!" 

}

# TODOs
# check if the enter is just one word 
# user can type databases full paths to be removed
function drobDatabase 
{
    echo "Enter Database name to drop: "
    read dbName
    if  checkDatabaseExists $dbName
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
    if  checkDatabaseExists $dbName
    then
        echo "ERROR! Database  Does Not Exists"
    else 
        cd ./databases/$dbName
        if checkLastCommand
        then 
            echo "Connected To Database Successfully"
            tempPS1=$PS1
            PS3="[$dbName]: "
            echo "testing PS3"
            read dd
        else 
            echo "ERROR Connecting To Database $dbName"
            
        fi
    fi
}

function listDatabases 
{
    ls ./databases
}

createDatabase
connectDatabase
exitDatabase
listDatabases
drobDatabase