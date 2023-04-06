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
        echo "$tableName Selected!"
        return 0
    else
        echo "Table $tableName DOES NOT EXIST!"
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
    # TODO: shouldn't create anything unless everything is validated   
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
        # MISSING CHECKING FOR TYPE SPECIALLY INT
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

# connectDatabase
# listTables 
# read -p "Enter table name from the listed tables--> " tableName 
# selectTable $tableName
# exitDatabase


# cut the line into column name and data type
# check if pk is set 
# if not find it in curr column name and edit the column name to be with out it

function insertIntoTable
{
    lineIndex=1
    fieldIndex=1
    colsNum=3
    nameIndex=1
    typeIndex=2

    recordValues=""
    tableName=$1
    # -s not to list anything not delimited 
    
    counter=0
    while [[ counter -lt colsNum ]]
    do
    
        colName=`cut -s -d  "|" -f $fieldIndex $tableName | cut -d ":" -f $nameIndex | head -1`
        colType=`cut -s -d  "|" -f $fieldIndex $tableName | cut -d ":" -f $typeIndex | head -1`
        read -p "Enter Column:[$colName] Value--> " colValue
        # TODO: test input and its datatyp
        recordValues+="$colValue|"
        # then check the recordValues
        # Finally Write them to file

        (( fieldIndex++ ))
        (( counter++ ))
    done
    

    # add new line to add the next record
    # printf "\n" >> $tableName
    printf "\n$recordValues" >> $tableName

}

insertIntoTable table