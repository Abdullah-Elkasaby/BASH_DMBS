Function to validate database name input
function validate_dbname() {

    # Prompt user to enter database name
    read -p "Enter database name: " dbname

    # Check for empty name
    if [[ $dbname = "" ]]; then
        echo "Error: database name is not set, please enter database name"
        return 1
    fi

    # Check for invalid characters
    if [[ $dbname =~ [^a-zA-Z0-9_] ]]; then
        echo "Error: invalid database name. Database names can only contain letters, digits, and underscores."
        return 1
    fi

    # Check for existing file
    if [[ -e $dbname ]]; then
        echo "Error: database '$dbname' already exists. Please enter a different name."
        return 1
    fi

    # Check for leading number or special character
    if [[ $dbname =~ ^[0-9] || $dbname =~ ^[^a-zA-Z0-9_] || $dbname =~ ^[\W_]+ ]]; then
        echo "Error: invalid database name. Database names cannot start with a number or special character."
        return 1
    fi

    # Validation successful
    return 0
}