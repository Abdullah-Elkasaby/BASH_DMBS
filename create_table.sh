
function isInteger
{   

    intPattern="^[0-9]+$"
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


function isValidString
{
    if [[ $1 =~ ^[a-zA-Z0-9]+$ ]]
    then
        return 0
    else
        return 1
    fi
}


function createTable
{   
    dbName=$1
    # user supposed to be in the database dir
    # TODO: shouldn't create anything unless everything is validated   
    read -p "Enter Table Name--> " tableName
    # TODO: validate tableName 

    # check if table exists
    if [ -f "./databases/$dbName/$tableName" ]
    then 
        echo "Error! Table Name Already Exsits!"
        return 1
    fi

    read -p "Enter Columns Number--> " columnsNumber
    # check if colsNum is int
    while ! isInteger $columnsNumber
    do 
        read -p "INVALID VALUE! `echo $'\n '` Enter Column:[$colName:$colType] Value--> " colValue        
    done


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
    printf $columnSchema >> "./databases/$dbName/$tableName"
    echo "Table $tableName was created successfully!"
}

# $1 is the Database Name
createTable $1