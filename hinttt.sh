

# function promptForPK
# {
# select ans in "yes" "no"
# do 
#     case $REPLY in 
#     1)  return 0
#         ;;
#     2)  return 1
#         ;;
#     *) echo "Invalidd Option"    
#     esac
     
# done

# }



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

function isValidString
{
    if [[ $1 =~ ^[a-zA-Z0-9]+$ ]]
    then
        return 0
    else
        return 1
    fi
}

# function promptIfNot
# {
#     # $1 should be the function
#     # $2 should be the input

#     validValue=""
#     # execute the function passed with its paramters
#     while ! "$@"
#     do
#         echo "Enter Value-->"
#         read validValue
#         set -- "$1" "$validValue"
#     done
#     echo "$validValue"
    
# }



# validValue2= promptIfNot `isInteger $validValue2`
# echo $validValue2

# function myfunc()
# {

#     local  myresult="some value $1"
#     echo "$myresult"
# }

# result=$(myfunc h)   # or result=`myfunc`
# echo $result hey