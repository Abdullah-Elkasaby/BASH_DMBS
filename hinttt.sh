

function promptForPK
{
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

