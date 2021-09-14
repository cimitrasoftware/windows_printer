# Control a Windows Spooler SubSystem App for Printing and Fax Services
# Author: Tay Kratzer tay@cimitra.com
# Modify Date: 9/14/21
# -------------------------------------------------

<#
.DESCRIPTION
Control the Windows Spooler SubSystem
#>

## This is the Parameters section ##
# Parameters have to be at the very top of a PowerShell script
# The Parameters section is an Array of elements
# Parameters are called or passed to the script with this synax: <script name> -Parameter
# Example Use: ./PrinterControl.ps1 -Report
Param(

[switch] $Report,
[switch] $Status,
[switch] $Start,
[switch] $Stop,
[switch] $Restart,
[switch] $ClearJobs,
[switch] $ReportJobs,
[switch] $CreateJob

)

# These are Global Variables
# Global Variables are meant to be accessible anywhere within a script
# The fact that these variables are not within any Function makes them available to the entire script
$Global:PrinterRunning = $true
$Global:SERVICE_NAME = "Spooler"

# This is a Try/Catch method
# In this script, the Try/Catch method is determining if the Windows Process spoolsv is running
try{
    $Global:ThePrinter = Get-Process spoolsv -ErrorAction Stop
}catch{
    $Global:PrinterRunning = $false
}


# This a Function
# Functions are like little programs within the script
function Stop-Printer(){

Write-Output "Stopped Print Server"

if($PrinterRunning){
    try{
        Stop-Service -Name ${SERVICE_NAME} -Force
    }catch{
        Write-Output "Unable to Stop Print Server"
    }
}

}

function Start-Printer(){

if($PrinterRunning){
    Stop-Printer
}

Write-Output "Restart Print Server"


try{
    $SUCCESS = Restart-Service -Name ${SERVICE_NAME} -Force -ErrorAction Stop 2> $null
}catch{
    Write-Output "Unable to Start Print Server"
    # Return from this function, because there is no need to go further if the Windows Service will not restart
    return
}


$Global:ThePrinter = Get-Process spoolsv -ErrorAction Stop
$Global:PrinterRunning = $true

}

function Printer-Queue-Report(){

# Get a listing of all files in the Printers Queue
$DIR_PRINT_QUEUE_FILES = ( Get-ChildItem $env:windir\system32\spool\PRINTERS\*.SPL | Measure-Object ).Count

if($DIR_PRINT_QUEUE_FILES -eq 1){
    Write-Output ""
    Write-Output "1 Print Job Exists"
}else{
    Write-Output ""
    Write-Output "$DIR_PRINT_QUEUE_FILES Print Jobs Exist"
}

}

function Clear-Printer-Queue(){

Write-Output "Clear Print Queue"

if($PrinterRunning){
    Stop-Printer
}

try{
    $REMOVE_PRINT_QUEUE = Remove-Item -Path $env:windir\system32\spool\PRINTERS\*.* 2> $null
}catch{}

if($PrinterRunning){
    Start-Printer
}

}

function Printer-PID-Report(){

if($PrinterRunning){
    $PrinterPID = $ThePrinter.Id
    Write-Output "Printer Process ID: [ $PrinterPID ]"
}

}

function Printer-Report(){

if($PrinterRunning){
    Write-Output "==========================="
    Write-Output "Printer Status: [ RUNNING ]"
    Write-Output ""
}else{
    Write-Output "==============================="
    Write-Output "Printer Status: [ NOT RUNNING ]"
    Write-Output "==============================="
    return
}


Printer-PID-Report

Printer-Queue-Report


Write-Output "==========================="

}

function Printer-Status(){

if($PrinterRunning){
    Write-Output "==========================="
    Write-Output "Printer Status: [ RUNNING ]"
    Write-Output "==========================="
}else{
    Write-Output "==============================="
    Write-Output "Printer Status: [ NOT RUNNING ]"
    Write-Output "==============================="
}

}


function Create-Test-Print-Job(){


if(!($PrinterRunning)){
    Write-Output "======================="
    Write-Output "Printer is Not Running"
    Write-Output "======================="
    return
}


try{
    $SUCCESS = Start-Job -ScriptBlock {try{Write-Output "Printer Test" | Out-Printer 1> $null 2> $null}catch{}} 1> $null 2> $null
}catch{}

Write-Output "========================"
Write-Output "Created A Test Print Job"
Write-Output "========================"

}


## These If(...) tests call a Function if a particular Parameter was sent to the script

# Run if the -Report Parameter was called
if($Report){
    Write-Output "Action - Printer Report"
    Write-Output ""
    Printer-Report
}

# Run if the -Status Parameter was called
if($Status){
    Write-Output "Action - Printer Status"
    Write-Output ""
    Printer-Status
}

# Run if the -Start Parameter was called
if($Start){
    Write-Output "Action - Start Printer"
    Write-Output ""
    Start-Printer
    Printer-Report
}

# Run if the -Stop Parameter was called
if($Stop){
    Write-Output "Action - Stop Printer"
    Write-Output ""
    Stop-Printer
  
}

# Run if the -Restart Parameter was called
if($Restart){
    Write-Output "Action - Restart Printer"
    Write-Output ""
    Stop-Printer
    Start-Printer
    Printer-Report
}


# Run if the -ClearJobs Parameter was called
if($ClearJobs){
    Write-Output "Action - Clear Print Jobs"
    Write-Output ""
    Printer-Queue-Report
    Clear-Printer-Queue
    Printer-Queue-Report

}

# Run if the -ReportJobs Parameter was called
if($ReportJobs){
    Write-Output "Action - Report Print Jobs"
    Write-Output ""
    Printer-Queue-Report
}

# Run if the -CreateJob Parameter was called
if($CreateJob){
    Write-Output "Action - Create a Print Job"
    Write-Output ""
    Printer-Queue-Report
    Create-Test-Print-Job
}
