# Cimitra Print Spooler Report Script
# Version 1.0
# Release Date: 10/19/2020
# Author: Tay Kratzer tay@cimitra.com
# ---------------------------------------

### MODIFY THESE THREE VALUES TO USE SCRIPT FOR OTHER WINDOWS SERVICES ###

###VARIABLES BEGIN###

$PROCESS_IN = "spoolsv"

$SERVICE_NAME = "Spooler"

$SERVICE_FRIENDLY_NAME = "Print Server"

###VARIABLES END###

# Make a temporary file
$TEMP_FILE=New-TemporaryFile

# Find the process spool service (spoolsv) and format output as a list (fl)
Get-Service ${SERVICE_NAME} | fl 1> $TEMP_FILE

# Get just the line that has the word "Status" in it
$STATUS_LINE = Select-String -Path $TEMP_FILE -Pattern "Status"

# Remove the Temp file
Remove-Item -Path $TEMP_FILE -Force

# Remove all spaces in the line (easier for parsing accurately with the next command)
$STATUS_LINE = $STATUS_LINE -replace " ", ""


# Get the first set column of data after the text "Id:", which is the process PID
$SERVICE_STATUS = ($STATUS_LINE -split "Status:")[1]
Write-Output ""
Write-Output "========================================"
Write-Output "Current ${SERVICE_FRIENDLY_NAME} Status: [ $SERVICE_STATUS ]"
Write-Output "========================================"
Write-Output ""
