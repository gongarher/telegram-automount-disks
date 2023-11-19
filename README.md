# Disk Checker and Docker Restarter

This script checks if specified disks are mounted and restarts Docker containers accordingly. It sends notifications to a Telegram channel for status updates.

## Installation

### Step 1: Customize Input File

Edit the `_input_folder_containers.txt` file to specify the disk paths and associated Docker container names:

```text
/mnt/folder1 container_name_1 container_name_2 container_name_3
/mnt/folder2 container_name_4
```

### Step 2: Configure Environment Variables
Create an env_vars.env file and set the following environment variables:
```bash
# Telegram bot token and chat ID
TELEGRAM_BOT_TOKEN="<YOUR-BOT-TOKEN-HERE>"
TELEGRAM_CHAT_ID="<YOUR-CHAT-ID-HERE>"

# Path to input file
CONFIG_FILE="/path/to/_input_folder_containers.txt"
```

### Step 3: Verify Checker Script
Check if the path to the env_vars.env file is correctly set in the checker.sh script:
```bash
#!/bin/bash

# Source the environment variables.
source /path/to/env_vars.env    # CHANGE with your custom path

# ... rest of the script ...
```

### Step 4: Set Execution Permissions
Give execution permissions to the checker.sh script:
```bash
chmod +x checker.sh
```

### Step 5: Configure Cron Job
Configure the cron job for the root user:

```bash
sudo crontab -u root -e
```
Add the following line to run the script every 5 minutes:
```text
*/5 * * * * /absolute/path/to/checker.sh
```

Replace /absolute/path/to/checker.sh with the actual path to your checker.sh script.

## Usage
The script will automatically check the specified disks, mount them if necessary, and restart the associated Docker containers. Telegram notifications will be sent for status updates.

## License
This project is licensed under the Apache License 2.0.
