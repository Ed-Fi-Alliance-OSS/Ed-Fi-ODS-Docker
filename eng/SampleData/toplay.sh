source ./.env

cat <<EOF | docker exec --interactive --user root ed-fi-db-ods-tenant1 sh

# Access the variables
echo "Variable 1 is: $VARIABLE1"
echo "Variable 2 is: $VARIABLE2"

cd /tmp
wget $VARIABLE3

EOF


# #!/bin/bash

# # Source the .env file
# source ./.env

# # Access the variables
# echo "Variable 1 is: $VARIABLE1"
# echo "Variable 2 is: $VARIABLE2"