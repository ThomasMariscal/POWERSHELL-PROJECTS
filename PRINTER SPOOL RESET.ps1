#CHALLENGE 5- WORKING WITH PARAMETERS

#REQUEST USER TO SPECIFY MAX FILE AGE(HOURS) OF SPOOLER FILES BEFORE DETERMINING SPOOLER RESET
Param(
   [Parameter(Mandatory= $true, HelpMessage = "Please provide a max file age(Hours) of spooler files before determining spooler reset")]
   $MaxAge
)
if ( $MaxAge )
{
Write-Host "Max file age set to $MaxAge hours"
}
else
{
$MaxAge = 6;
Write-Host "Max file age will default to 6 hours"
}

#RETRIEVE COUNT OF FILES IN SPOOLER FOLDER THAT ARE OLDER THAN $MaxAge HOURS
"RETRIEVING COUNT OF FILES IN SPOOLER FOLDER THAT ARE OLDER THAN $MaxAge HOURS TO DETERMINE IF PRINT SPOOLER NEEDS TO RESTART:"

pause;

#IF FILE COUNT IN SPOOLER FOLDER REVEALS FILES OLDER THAN $MaxAge HOURS, RESTART PRINTER SPOOLER
$PrintSpoolerCountAge = (Get-ChildItem -Path "C:\Windows\System32\spool\PRINTERS\*.*" -Recurse | `
Where-Object {((Get-Date) - $_.CreationTime).TotalHours -gt $MaxAge} ).Count
if ($PrintSpoolerCountAge -eq 0)
{
Write-Host "All Good! No Spool Files older than $MaxAge hours."
}
else
{
Restart-Service -Name Spooler
"PRINTER SPOOLER HAS BEEN RESET"
}

pause; clear;