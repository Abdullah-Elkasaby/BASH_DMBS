#!/bin/bash

function checkDatabaseExists 
{
    if [ -d ./databases/$1 ]
    then
        return 0
    else 
     
        return 1
    fi
}

# IT can't be written inside square brackets becuase
# the if condition is originally if test function . so it checks if function is empty string
# which not what I want

if ! checkDatabaseExists $1; 
then
    echo true
else 

    echo false
fi



# In Bash, when you use an array variable without enclosing it in quotes, 
# the elements of the array are subject to word splitting and globbing. Word splitting means that the shell
# breaks up the elements of the array into separate words based on whitespace characters (such as spaces and tabs).
# Globbing means that the shell performs filename expansion,
# replacing any special characters (such as * and ?) with filenames that match the patterns.


: << COMMENT_BLOCK 
CHECK THE PS1 change stuff
COMMENT_BLOCK

# NOTICE the not is infront
# ! [[ -z $tableName ]]