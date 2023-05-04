#!/bin/bash

updateTable () {
    #check if table does not exist
    read -p "Enter table name: " tablename
    tablename="$1/$tablename"
    
    if [[ ! -f $tablename ]]; then
        echo "table '$tablename' does not exist."
        return 1
    fi
    
    ###########
    
    read -p "Enter the name and data type of the column to update (in the format 'name of column:datatype'): " columnToUpdate
    Numofcol=$(awk -F'|' -v col="$columnToUpdate" 'NR==1{for(i=1;i<=NF;i++)if($i==col)print i}' "$tablename")
    
    #check if column does not exist
    if [[ -z $Numofcol ]]; then
        echo "Column '$columnToUpdate' does not exist in table '$tablename'."
        return 1
    fi
    
    ############
    
    #check if col name == pattern (value of col) 
    read -p "Enter value of '$columnToUpdate' for the row to update: " colToUpdateValue
    NumofRow=$(awk -F'|' -v col="$Numofcol" -v val="$colToUpdateValue" '$col==val{print NR}' "$tablename")
    
    if [[ -z $NumofRow ]]; then
        echo "No rows found for condition '$columnToUpdate=$colToUpdateValue'."
        return 1
    fi
    
    ############
    #name:string
    colType=$(cut -d'|' -f$Numofcol "$tablename" | cut -d':' -f2 | head -1)
    
    #...
    while true; do
        read -p "Enter new value: " newValue
        
        if [[ -z $newValue ]]; then
            echo "Error: new value is not set, please enter new value."
            continue
        fi
        
        if ! [[ "$newValue" =~ ^[a-zA-Z0-9_]+$ ]]; then
            echo "Error: invalid argument. Only letters, digits, and underscores are allowed."
            continue
        fi
        
        if [[ "$newValue" =~ ^[_] ]]; then
            echo "Error: new value cannot start with an underscore."
            continue
        fi
        
        if [[ "$columnToUpdate" == *"PK"* ]]; then
            if awk -F'|' -v col="$Numofcol" -v val="$newValue" '$col==val{print}' "$tablename" | grep -q '[^[:space:]]'; then
                echo "Value '$newValue' already exists in column '$columnToUpdate'."
                continue
            fi
        fi
        
        break
    done
    
    # Write updated contents to a new file
    awk -v row="$NumofRow" -v col="$Numofcol" -v val="$newValue" 'BEGIN{FS=OFS="|"} NR==row{$col=val}1' "$tablename" > "$tablename.tmp"
    
    # Replace old file with new file
    mv "$tablename.tmp" "$tablename"
    
    echo "Update successful."
}

updateTable $1
