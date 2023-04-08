#!/bin/bash
function dropTable {
    echo "Enter table name to drop: "
    read tbName
    if ! [[ -f $tbName ]]
    then
        echo "ERROR! Database  Does Not Exist"
    else 
        rm -r $tbName
        # check if cmd was a success
        if [ $? ] 
        then 
            echo "table Dropped Successfully"
        else
            echo "Error Deleting $tbName" 
        fi
    fi
}