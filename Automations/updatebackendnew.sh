#!/bin/bash

INSTANCE_ID="i-06d0ad19f7e9c0e4d"  # Replace with your actual instance ID

# Get the public IPv4 address of the EC2 instance
ipv4_address=$(aws ec2 describe-instances --instance-ids "$INSTANCE_ID" --query "Reservations[0].Instances[0].PublicIpAddress" --output text)


file_to_find="../backend/.env.docker"  # Replace with the relative path to your .env.docker file

current_url=$(sed -n "4p" $file_to_find) # Get the current URL from the .env.docker file (assuming it's on line 4)


# Update the FRONTEND_URL in the .env.docker file if it doesn't match the current IPv4 address
if [[ "$current_url" != "FRONTEND_URL=\"http://${ipv4_address}:5173\"" ]]; then
    # Update the FRONTEND_URL in the .env.docker file
    if [ -f "$file_to_find" ]; then
        # Update the FRONTEND_URL in the .env.docker file
        sed -i -e "s|FRONTEND_URL.*|FRONTEND_URL=\"http://${ipv4_address}:5173\"|g" $file_to_find 
    else
        echo "File not found: $file_to_find"
    fi
fi

