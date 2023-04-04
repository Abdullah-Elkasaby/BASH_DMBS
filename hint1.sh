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