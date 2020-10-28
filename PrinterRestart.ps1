$TEMP_FILE=New-TemporaryFile

Get-Process spoolsv* | fl 1> $TEMP_FILE

$PID_LINE = Select-String -Path $TEMP_FILE -Pattern "Id"

$PID_LINE = $PID_LINE -replace " ", ""

Remove-Item -Path $TEMP_FILE -Force

$PROCESS_PID = ($PID_LINE -split "Id:")[1]

Write-Output "================================================="
Write-Output "Current Print Server Process ID: [ $PROCESS_PID]"
Write-Output "================================================="
Write-Output "Restarting Print Server"
Restart-Service -Name Spooler -Force

$TEMP_FILE=New-TemporaryFile

Get-Process spoolsv* | fl 1> $TEMP_FILE

$PID_LINE = Select-String -Path $TEMP_FILE -Pattern "Id"

$PID_LINE = $PID_LINE -replace " ", ""

Remove-Item -Path $TEMP_FILE -Force

$PROCESS_PID = ($PID_LINE -split "Id:")[1]

Write-Output "================================================="
Write-Output "New Print Server Process ID:     [ $PROCESS_PID ]"
Write-Output "================================================="