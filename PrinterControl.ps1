# Control a Windows Spooler SubSystem App for Printing and Fax Services
# Author: Tay Kratzer tay@cimitra.com
# Modify Date: 9/8/21
# -------------------------------------------------

<#
.DESCRIPTION
Control the Windows Spooler SubSystem
#>

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

$Global:PrinterRunning = $true
$Global:SERVICE_NAME = "Spooler"

try{
    $Global:ThePrinter = Get-Process spoolsv -ErrorAction Stop
}catch{
    $Global:PrinterRunning = $false
}


function Stop-Printer(){

Write-Output "Stopped Print Server"

if($PrinterRunning){
    try{
        Stop-Service -Name ${SERVICE_NAME} -Force
    }catch{
        Write-Output "Unable to Stop Print Server"
        return
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
    return
}


$Global:ThePrinter = Get-Process spoolsv -ErrorAction Stop
$Global:PrinterRunning = $true

}

function Printer-Queue-Report(){

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
    #Write-Output "==========================="
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
    return
}

}


function Create-Test-Print-Job(){


if(!($PrinterRunning)){
    Start-Printer
}


try{
    $SUCCESS = Start-Job -ScriptBlock {try{Write-Output "Printer Test" | Out-Printer 1> $null 2> $null}catch{}} 1> $null 2> $null
}catch{}

Write-Output "========================"
Write-Output "Created A Test Print Job"
Write-Output "========================"

}


if($Report){
    Write-Output "Action - Printer Report"
    Write-Output ""
    Printer-Report
}

if($Status){
    Write-Output "Action - Printer Status"
    Write-Output ""
    Printer-Status
}

if($Start){
    Write-Output "Action - Start Printer"
    Write-Output ""
    Start-Printer
    Printer-Report
}

if($Stop){
    Write-Output "Action - Stop Printer"
    Write-Output ""
    Stop-Printer
  
}

if($Restart){
    Write-Output "Action - Restart Printer"
    Write-Output ""
    Stop-Printer
    Start-Printer
    Printer-Report
}


if($ClearJobs){
    Write-Output "Action - Clear Print Jobs"
    Write-Output ""
    Printer-Queue-Report
    Clear-Printer-Queue
    Printer-Queue-Report

}

if($ReportJobs){
    Write-Output "Action - Report Print Jobs"
    Write-Output ""
    Printer-Queue-Report
}

if($CreateJob){
    Write-Output "Action - Create a Print Job"
    Write-Output ""
    Printer-Queue-Report
    Create-Test-Print-Job
}
