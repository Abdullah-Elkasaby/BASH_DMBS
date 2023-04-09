#!/bin/bash

Delete_Function() {
    read -p "Enter table name: " tableName
    tableName="$1/$tableName"
    if [[ ! -f $tableName ]]; then
        echo "Table '$tableName' does not exist."
        return 1
    fi

     ##########################

    mapfile -t lines < "$tableName"
    
    # Extract column names from first line
    IFS='|' read -ra columns <<< "${lines[0]}"
    
    # Find primary key column index
    pkIndex=-1
    for i in "${!columns[@]}"; do
        if [[ "${columns[i]}" == *"(PK)"* ]]; then
            pkIndex=$i
            break
        fi
    done
    
    if [[ $pkIndex == -1 ]]; then
        echo "Primary key column not found in table '$tableName'."
        return 1
    fi
    ###########################
    read -p "Enter the primary key value of the row you want to delete: " primaryKeyValue
    
    # Delete matching rows from array of lines
    deleted=0
    for i in "${!lines[@]}"; do
        if [[ $i == 0 ]]; then
            continue # Skip header row
        fi
        
        IFS='|' read -ra values <<< "${lines[i]}"
        
        if [[ "${values[pkIndex]}" == "$primaryKeyValue" ]]; then
            unset lines[i]
            deleted=1
        fi
    done
    
    if [[ $deleted == 0 ]]; then
        echo "No rows with primary key value '$primaryKeyValue' found in table '$tableName'."
        return 1
    fi
    
    # Write updated array of lines back to file
    printf '%s\n' "${lines[@]}" > "$tableName"
    
    echo "Rows with primary key value '$primaryKeyValue' deleted from table '$tableName'."




   
   
}

Delete_Function $1
