#!/bin/bash
function tableMenu
{
    options=("Create Table" "List Tables" "Insert into Table" "Update Table" "Delete from Table" "Drop Table")
    select opt in "${options[@]}" 
    do
        case $REPLY in 
            1) echo createTable
                ;;
            2) echo listTables
                ;;
            3) echo insertIntoTable
                ;;
            4) echo updateTable
                ;;
            5) echo DeleteFromTable
                ;;
            6) echo dropTable
                ;;
            *) echo CHOICE DOES NOT EXIST!
                ;; 
        esac
            
    done 
}

# tableMenu


function listTables
{
    ls -p | grep -v /
}

# The user should be in the database he wants, so select database beforhand
function selectTable 
{
    tableName=$1
    # checking if it's in the database which we are connected to
    if [[ -f $(pwd)/$tableName ]] && ! [[ -z $tableName ]]
    then
        echo EXISTS
        return 0
    else
        echo DOESNOT EXIST!
        return 1
    fi

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

function exitDatabase 
{
    cd ../../
}


function isInteger
{   

    intPattern="^[0-9]+"
    if [[ $1 =~ $intPattern ]]
    then
        return 0
    else 
        return 1
    fi
}



function promptForPK
{
    echo "Make Current Column The Primary Key? "    
    select ans in "yes" "no"
    do 
        case $REPLY in 
        1)  return 0
            ;;
        2)  return 1
            ;;
        *) echo "Invalidd Option"    
        esac
        
    done

}



function createTable
{
    
    read -p "Enter Table Name--> " tableName
    read -p "Enter Columns Number--> " columnsNumber
    # check if colsNum is int
    # validate tableName 
    # check if table exists
    if [ -f $tableName ]
    then 
        echo "Error! Table Name Already Exsits!"
        return 1
    fi
    typeset -i counter=0
    columnSchema=""
    primKey=''
    while  [[ counter -lt columnsNumber ]]
    do
        currCol=$(( counter+1 ))
        # MISSING CHECKING FOR TYPE
        read -p "Enter Column [$currCol] Name--> " colName
        echo "Enter Column [$currCol] Type--> "
        select type in "int" "string"
        do
            case $REPLY in 
                1|2) colType=$type
                    break ;;
                *) echo "Invalid Option"
            esac
        done 
        # prompt user for a primary key choice if not set
        if [ -z $primKey ]
        then
            promptForPK
            if [ $? -eq 0 ] 
            then 
                primKey=$colName
                colName+="(PK)"
            fi  
        fi

        # valdiate against the seperator in input names
        columnSchema+="$colName:$colType|"
        
        ((counter++))
    done
    # TODO: Handle the case of no PK
    # create a file and add the schema to it
    # user should be connected to the database i.e in the db dir
    printf $columnSchema >> $tableName
    echo $columnSchema
}

# createTable

connectDatabase
listTables 
# selectTable
# exitDatabase



# select the table
# 
function insertIntoTable
{
    read -p "Enter Table Name--> " tableName
    if selectTable tableName
    then
        :
    fi
}