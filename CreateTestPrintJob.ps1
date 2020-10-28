# Cimitra Print Test Script
# Version 1.0
# Release Date: 10/20/2020
# Author: Tay Kratzer tay@cimitra.com
# ---------------------------------------

$DIR_PRINT_QUEUE_FILES = ( Get-ChildItem $env:windir\system32\spool\PRINTERS\*.SPL | Measure-Object ).Count

if($DIR_PRINT_QUEUE_FILES -eq 1){
Write-Output ""
Write-Output "==============="
Write-Output "1 Print Job Exists"
Write-Output "==============="
}else{
Write-Output ""
Write-Output "=============="
Write-Output "$DIR_PRINT_QUEUE_FILES Print Jobs Exist"
Write-Output "=============="
}


Write-Output "Printer Test" | Out-Printer

Write-Output "====================="
Write-Output "Created A Test Print Job"
Write-Output "====================="


$DIR_PRINT_QUEUE_FILES = ( Get-ChildItem $env:windir\system32\spool\PRINTERS\*.SPL | Measure-Object ).Count

if($DIR_PRINT_QUEUE_FILES -eq 1){

Write-Output "=================="
Write-Output "1 Print Job Exists"
Write-Output "=================="
}else{

Write-Output "=============="
Write-Output "$DIR_PRINT_QUEUE_FILES Print Jobs Exist"
Write-Output "=============="
}