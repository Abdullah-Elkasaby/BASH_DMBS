#!/bin/bash


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
    if ! validate_dbname $dbName
    then
        return 1
        # needs paramter
    elif checkDatabaseExists $dbName
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


    echo "Database[$dbName] Created Successfuly!" 

}

# TODOs
# check if the enter is just one word 
# user can type databases full paths to be removed
function drobDatabase 
{
    echo "Enter Database name to drop: "
    read dbName
    if ! [[ -d databases/$dbName ]]
    then
        echo "ERROR! Database  Does Not Exist"
    else 

        echo "Confirm Removing Database[$dbName]."
        select opt in "Confrim" "Cancel"
        do
            case $REPLY in
            1)  break ;;
            2)  echo "Exited!"
                return ;;
            esac
        done

        rm -r databases/$dbName
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
    if ! [[ -d databases/$dbName ]]
    then
        echo "ERROR! Database  Does Not Exists"
    else 
        clear
        echo "Connected To Database Successfully"
        source table_menu.sh "./databases/$dbName"
    fi
    
}

function listDatabases 
{
    counter=1
    for dbName in `ls ./databases`
    do 
        echo "Database[$(( counter++ ))]--> $dbName "
    done

}



function start_dbms
{   
    echo
    echo "Select an option"
    options=("Create a new database" "List all databases" "Connect to a specific database" "Drop a database" "Quit")
    select opt in "${options[@]}" 
    do
        case $REPLY in
            1)    clear
                createDatabase 
                start_dbms 
                ;;
            2)  clear 
                listDatabases 
                echo "_________________________________________"
                start_dbms
                 ;;
            3)  connectDatabase  
                ;;

            4)  drobDatabase 
                start_dbms ;;
            5)  exit ;;
            *)  echo "Invalid option. Please try again." ;;
        esac
    done
}

start_dbms
