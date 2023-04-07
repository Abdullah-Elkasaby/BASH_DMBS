#!/bin/bash

function validate_dbname() {

    # Check for empty name
    if [[ $dbName = "" ]]; then
        echo "Error: database name is not set, please enter database name"
        return 1
    fi

    # Check for invalid characters
    if [[ $dbName =~ [^a-zA-Z0-9_] ]]; then
        echo "Error: invalid database name. Database names can only contain letters, digits, and underscores."
        return 1
    fi
   # Check for existing database
    if [[ -d $dbName ]]; then
        echo "Error: database '$dbName' already exists. Please enter a different name."
        return 1
    fi
    # Check for leading number or special character
    if [[ $dbName =~ ^[0-9] || $dbName =~ ^[^a-zA-Z0-9_] || $dbName =~ ^[\W_]+ ]]; then
        echo "Error: invalid database name. Database names cannot start with a number or special character."
        return 1
    fi

    # Validation successful
    return 0
}

function validate_tableName() {




    # Check for empty name
    if [[ $tableName = "" ]]; then
        echo "Error: table name is not set, please enter table name"
        return 1
    fi

    # Check for invalid characters
    if [[ $tableName =~ [^a-zA-Z0-9_] ]]; then
        echo "Error: invalid table name. table names can only contain letters, digits, and underscores."
        return 1
    fi

    # Check for existing file
    if [[ -f $tableName ]]; then
        echo "Error: table '$tableName' already exists. Please enter a different name."
        return 1
    fi

    # Check for leading number or special character
    if [[ $tableName =~ ^[0-9] || $tableName =~ ^[^a-zA-Z0-9_] || $tableName =~ ^[\W_]+ ]]; then
        echo "Error: invalid table name. table names cannot start with a number or special character."
        return 1
    fi

    # Validation successful
    return 0
}
function createTable() {
    read -p "Please enter table name: " tableName
      validate_tableName
  
    if [ -f "$tableName" ]; then
        echo "Table already exists."
        tableMenu
        return
    fi

    read -p "Enter number of columns: " colNum

     

    columns=() # empty array called columns
    for ((i=0; i<$colNum; i++)); do
        read -p "Enter column name: " colName

        while [ -z "$colName" ]; do
            echo "Column name cannot be empty."
            read -p "Enter column name: " colName
        done

        read -p "Enter column type: " colType
        while [ -z "$colType" ]; do
            echo "column type cannot be empty."
            read -p "Enter column type: " colType
        done

        columns+=("$colName:$colType")
         read -p "Enter primary key: " pk

        if [ -z "$pk" ]; then
            read -p "Is this column a primary key? (y/n): " answer
            if [ "$answer" == "y" ]; then
                pk="$colName"
            fi
        fi
     read -p "To exit, type exit" e
      if [[ "$e" =~ "exit" ]]; then
            exit
      fi

    done

    echo "${columns[@]}" > "$tableName"
    echo "Table created successfully."
    tableMenu
}

function tableMenu {
    PS3="Select an option: "
    options=("Create table" "Insert into table" "Drop table" "Select from table" "Exit")
    select option in "${options[@]}"
    do 
        case $option in 
        "Create table")
            createTable
            tableMenu
            ;;  
        "Insert into table")
            insertIntoTable
            tableMenu
            ;;
        "Drop table")
            dropTable
            tableMenu
            ;;
        "Select from table")
            selectAll
            tableMenu
            ;;
        "Exit")
            break
            ;;
        *) 
            echo "Invalid option. Please select from the menu."
            ;;
        esac
    done
}




function exitDatabase 
{
    cd ../../
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
    if ! validate_dbname $dbName
    then
        return 1
    
    fi 

    mkdir ./databases/$dbName
    if ! checkLastCommand
    then 
        echo "Error Creating $dbName" 
        return 1
    fi


    echo "Database Created Successfuly!" 
 tableMenu
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
    if ! [[ -d databases/$dbName ]]
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
           
        else 
            echo "ERROR Connecting To Database $dbName"
            
        fi
    fi
    
}

function listDatabases 
{
    ls ./databases
}

while true; do
    echo "Select an option:"
    echo "1. Create a new database"
    echo "2. List all databases"
    echo "3. Connect to a specific database"
    echo "4. Drop a database"
    echo "5. Quit"

    read -p "Enter option number: " choice

    case $choice in
        1) createDatabase ;;
        2) listDatabases  ;;
        3) connectDatabase ;;
        4) drobDatabase ;;
        5) exit ;;
        *) echo "Invalid option. Please try again." ;;
    esac

    echo
done