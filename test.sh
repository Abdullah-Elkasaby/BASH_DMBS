#!/bin/bash

source ./run_dbms.sh
# Test case 1: Empty database name should return error code 1
validate_dbname ""
echo $?
# Output: 1

# Test case 2: Database name with only letters, digits and underscores should return success code 0
validate_dbname "my_database_123"
echo $?
# Output: 0

# Test case 3: Database name with invalid character should return error code 1
validate_dbname "my-database-123"
echo $?
# Output: 1

# Test case 4: Database name starting with a number should return error code 1
validate_dbname "123database"
echo $?
# Output: 1

# Test case 5: Database name starting with special character should return error code 1
validate_dbname "_database"
echo $?
# Output: 1

# Test case 6: Database name starting with multiple special characters should return error code 1
validate_dbname "__database"
echo $?
# Output: 1
