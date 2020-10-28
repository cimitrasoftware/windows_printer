# Cimitra Print Job Report Script
# Version 1.0
# Release Date: 10/22/2020
# Author: Tay Kratzer tay@cimitra.com
# ---------------------------------------

### MODIFY THESE THREE VALUES TO USE SCRIPT FOR OTHER WINDOWS SERVICES ###

###VARIABLES BEGIN###



###VARIABLES END###

$DIR_PRINT_QUEUE_FILES = ( Get-ChildItem $env:windir\system32\spool\PRINTERS\*.SPL | Measure-Object ).Count

if($DIR_PRINT_QUEUE_FILES -eq 1){
Write-Output ""
Write-Output "===================="
Write-Output "There is 1 Print Job"
Write-Output "===================="
}else{
Write-Output ""
Write-Output "========================"
Write-Output "There are $DIR_PRINT_QUEUE_FILES Print Jobs"
Write-Output "========================"
}