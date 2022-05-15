#CHALLENGE 5- WORKING WITH PARAMETERS

#REQUEST USER TO SPECIFY FOLDER/PATH TO STORE 'RUNNING SERVICES' HTML FILE
Param(
   [Parameter(Mandatory=$true, HelpMessage = "Please provide a valid path to store 'Running Services' HTML File in C:\")]
   $HTMLpath
)
if ( (Test-Path "C:$HTMLpath" -PathType Container) -eq $false )
{
New-item -Path "c:\$HTMLpath" -ItemType Directory
}
Write-Host "File will be stored at path C:\$HTMLPath"


#EXPORT RUNNING SERVICES TO AN HTML FILE
$currentdate = (Get-Date).tostring("MMddyyyy");
Get-Service | Where-Object {$_.status -eq "running"} | ConvertTo-Html | `
Out-File -FilePath "C:\$HTMLpath\$currentdate.htm";
"TODAY'S RUNNING SERVICES HAVE BEEN EXPORTED IN HTML FORMAT"
