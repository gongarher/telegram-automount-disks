#!/bin/bash

# Source the environment variables.
source /path/to/env_vars.env    # CHANGE with your custom path

# Read folder locations and Docker container names from the file
while IFS= read -r line; do
    # Extract folder and Docker container names from the line
    folder=$(echo "${line}" | cut -d' ' -f1)
    container_names=$(echo "${line}" | cut -d' ' -f2-)

    # Check if the folder is empty
    if [ -z "$(ls -A "${folder}")" ]; then
        # Log the error
        echo "Disk not mounted on ${folder}"
        # Send Telegram message using curl
        curl -s -X POST \
            https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage \
            -d chat_id=${TELEGRAM_CHAT_ID} \
            -d text="No found any disk mounted on ${folder}, mounting..." > /dev/null

        # Mount the unmounted disk according to /etc/fstab
        mount ${folder}
        curl -s -X POST \
            https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage \
            -d chat_id=${TELEGRAM_CHAT_ID} \
            -d text="A disk is now mounted on ${folder}, restarting containers:%0A${container_names}" > /dev/null

        # Restart Docker containers
        for container_name in ${container_names}; do
            docker restart "${container_name}" > /dev/null
            if [ $? -ne 0 ]; then
                # If restart fails, send an error message and exit the script
                curl -s -X POST \
                    https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage \
                    -d chat_id=${TELEGRAM_CHAT_ID} \
                    -d text="ERROR: Failed to restart Docker container ${container_name}. Check if container exists" > /dev/null
                exit 1
            fi
        done

        # Send Telegram message using curl
        curl -s -X POST \
            https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage \
            -d chat_id=${TELEGRAM_CHAT_ID} \
            -d text="Success! Containers ${container_names} restarted." > /dev/null

    else
        echo "Nothing to do: Disk is already mounted on ${folder}"
    fi
done < "${CONFIG_FILE}"