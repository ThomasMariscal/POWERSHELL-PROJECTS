#CHALLENGE 5- WORKING WITH PARAMETERS

#REQUEST USER TO SPECIFY FOLDER/PATH TO STORE 'RUNNING SERVICES DETAILS' JSON FILE
Param(
   [Parameter(Mandatory=$true, HelpMessage = "Please provide a valid path to store 'Running Services Details' JSON File in C:\")]
   $JSONpath
)
if ( (Test-Path "C:$JSONpath" -PathType Container) -eq $false )
{
New-item -Path "c:\$JSONpath" -ItemType Directory
}
Write-Host "File will be stored at path C:\$JSONPath"


#EXPORTED DETAILS TO A JSON FILE
$currentdate = (Get-Date).tostring("MMddyyyy");
Get-WmiObject -Class Win32_service | Where-Object {$_.state -eq "running"} | `
ft -Property Name, @{n='Status'; e={$_.state}}, @{n='Start Up Type'; e={$_.startmode}}, @{n='File Location'; e={$_.pathname}} | `
ConvertTo-Json | Out-File -FilePath  "C:\$JSONPath\$currentdate.json";
"TODAY'S RUNNING SERVICES DETAILS HAVE BEEN EXPORTED IN JSON FORMAT"