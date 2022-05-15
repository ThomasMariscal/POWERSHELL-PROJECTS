#POWERSHELL CHALLENGE LAB-WINDOWS SERVER-POWERSHELL ADMINISTRATION
#THOMAS MARISCAL
#PSCA5

#CHALLENGE 1-START WITH COMMANDS-----------------------------------------------------------------------------

#LIST THE COMMANDS USED FOR SERVICES IN THE MANAGEMENT MODULE
Get-Command -Module Microsoft.PowerShell.Management *service*;

#SCRIPT PAUSE
pause;

#COUNT OF SERVICES ON THE WINDOWS SERVER
"Count of Services on the Windows Server:"
(Get-Service).count

#SCRIPT PAUSE
pause;

#COMMAND(S) TO RESTART THE PRINT SPOOLER SERVICE ON THE LOCAL COMPUTER
#Restart-Service -Name Spooler
"PRINTER SPOOLER HAS BEEN RESET"

#SCRIPT PAUSE AND CLEAR FOR NEXT CHALLENGE
pause; clear;


#CHALLENGE 2-GETTING DETAILS OF RUNNING SERVICES-------------------------------------------------------------

#LISTING OF ONLY THOSE SERVICES THAT ARE RUNNING
"LISTING OF ONLY THOSE SERVICES THAT ARE RUNNING:"
Get-Service | Where-Object {$_.status -eq "running"}

#SCRIPT PAUSE AND CLEAR FOR NEXT STEP
pause; clear;

#ALL SERVICE DETAILS LISTED WITH: -NAME,-STATUS,-STARTUP,-FILE LOCATION
"ALL SERVICE DETAILS LISTED WITH: -NAME,-STATUS,-STARTUP,-FILE LOCATION"
Get-WmiObject -Class Win32_service | Where-Object {$_.state -eq "running"} | `
ft -Property Name, @{n='Status'; e={$_.state}}, @{n='Start Up Type'; e={$_.startmode}}, @{n='File Location'; e={$_.pathname}}

#SCRIPT PAUSE AND CLEAR FOR NEXT CHALLENGE
pause; clear;

#CHALLENGE 3-WORKING WITH FILES------------------------------------------------------------------------------

#EXPORT RUNNING SERVICES TO AN HTML FILE
$currentdate = (Get-Date).adddays(0).tostring("MMddyyyy");
Get-Service | Where-Object {$_.status -eq "running"} | ConvertTo-Html | `
Out-File -FilePath "C:\RUNNING SERVICES\RUNNING SERVICES HTML\$currentdate.htm";
"TODAY'S RUNNING SERVICES HAVE BEEN EXPORTED IN HTML FORMAT"

#SCRIPT PAUSE AND CLEAR FOR NEXT STEP
pause; clear;

#EXPORTED DETAILS TO A JSON FILE
Get-WmiObject -Class Win32_service | Where-Object {$_.state -eq "running"} | `
ft -Property Name, @{n='Status'; e={$_.state}}, @{n='Start Up Type'; e={$_.startmode}}, @{n='File Location'; e={$_.pathname}} | `
ConvertTo-Json | Out-File -FilePath  "C:\RUNNING SERVICES\RUNNING SERVICES DETAILED JSON\$currentdate.json";
"TODAY'S RUNNING SERVICES DETAILS HAVE BEEN EXPORTED IN JSON FORMAT"

#SCRIPT PAUSE AND CLEAR FOR NEXT CHALLENGE
pause; clear;

#CHALLENGE 4- IDENTIFY STATUS OF SERVICES--------------------------------------------------------------------

#RETRIEVE FILE COUNT FOR 'RUNNING SERVICES' FILES CREATED TODAY. IF THERE ARE NONE, AN ERROR IS DISPLAYED
"RETRIEVING FILE COUNT ON WINDOWS SERVER FOR 'RUNNING SERVICES' FILES CREATED TODAY.  IF THERE ARE NONE, AN ERROR IS DISPLAYED:"
pause;

$FilesCreatedToday = (Get-ChildItem -Path "C:\RUNNING SERVICES\*.*" -Recurse | Where-Object {$_.CreationTime -gt (Get-Date).Date} ).Count
if ($FilesCreatedToday -eq 0)
{
Write-Host "ERROR! NO FILES CREATED TODAY!"
}
else
{
Write-Host "All Good! Files for running services have been created today"
}

#SCRIPT PAUSE AND CLEAR FOR NEXT STEP
pause; clear

#RETRIEVE COUNT OF FILES IN SPOOLER FOLDER THAT ARE OLDER THAN 6 HOURS
"RETRIEVING COUNT OF FILES IN SPOOLER FOLDER THAT ARE OLDER THAN 6 HOURS TO DETERMINE IF PRINT SPOOLER NEEDS TO RESTART:"

pause;

#IF FILE COUNT IN SPOOLER FOLDER REVEALS FILES OLDER THAN 6 HOURS, RESTART PRINTER SPOOLER
$PrintSpoolerCountAge = (Get-ChildItem -Path "C:\Windows\System32\spool\PRINTERS\*.*" -Recurse | `
Where-Object {((Get-Date) - $_.CreationTime).TotalHours -gt 6} ).Count
if ($PrintSpoolerCountAge -eq 0)
{
Write-Host "All Good! No Spool Files older than 6 hours."
}
else
{
Restart-Service -Name Spooler
"PRINTER SPOOLER HAS BEEN RESET"
}

pause; clear;