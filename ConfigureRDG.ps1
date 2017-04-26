 <#
.SYNOPSIS
ConfigureRDG.ps1 

.DESCRIPTION 



.PARAMETER



.EXAMPLE
.\ConfigureRDG.ps1 


.NOTES
Written by: Drago Petrovic

Run the Script from a Remote Server!

https://blogs.technet.microsoft.com/askperf/2015/03/04/step-by-step-instructions-for-installing-rds-session-deployment-using-powershell-in-windows-server-2012-r2/

.TROUBLENOTES



Find me on:

* LinkedIn:	https://www.linkedin.com/in/drago-petrovic-86075730/
* Xing:     https://www.xing.com/profile/Drago_Petrovic
* Website:  https://blog.abstergo.ch
* GitHub:   https://github.com/MSB365


Change Log
V1.00, 12/02/2017 - Initial version


--- keep it simple, but significant ---

.COPYRIGHT
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), 
to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, 
and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, 
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#>


#


Write-Host "NOTE: Run this Script from a Remote server!" -ForegroundColor Magenta
Write-Host "--- keep it simple, but significant ---" -ForegroundColor yellow

# Variables
Write-Host "Set Variables" -ForegroundColor cyan
$RDServer = Read-Host -Prompt "Set RDServer - example: RDG001.abstergo.ch"
$DCServer = Read-Host -Prompt "Set DCServer - example: ADC002.abstergo.ch"
$ExtRDG = Read-Host -Prompt "Set external RDG Path - example: rdg.abstergo.ch"
Write-Host "done" -ForegroundColor green
 
# Scripts
Write-Host "Importing Remote Desktop Module" -ForegroundColor cyan
Import-Module RemoteDesktop
Write-Host "done" -ForegroundColor green 

Write-Host "Start RDSession deployment" -ForegroundColor cyan
New-RDSessionDeployment -ConnectionBroker $RDServer -WebAccessServer $RDServer -SessionHost $RDServer
Write-Host "done" -ForegroundColor green 

Write-Host "Adding RDS to ADC" -ForegroundColor cyan
Add-RDServer -Server $DCServer -Role RDS-LICENSING -ConnectionBroker $RDServer
Write-Host "done" -ForegroundColor green

Write-Host "Setting up License Server" -ForegroundColor cyan
Set-RDLicenseConfiguration -LicenseServer $DCServer -Mode PerUser -ConnectionBroker $RDServer
Write-Host "done" -ForegroundColor green
 
#Get-RDLicenseConfiguration
Write-Host "Setting up RDS Collection" -ForegroundColor cyan
New-RDSessionCollection –CollectionName SessionCollection –SessionHost $RDServer –CollectionDescription “This Collection is for Desktop Sessions” –ConnectionBroker $RDServer
Write-Host "done" -ForegroundColor green
# Add-WindowsFeature RDS-Gateway -IncludeAllSubFeature # Not needed from the remote server
Write-Host "Setting up Connection Broker with public RDG Path" -ForegroundColor cyan
Add-RDServer -Server $RDServer -Role "RDS-Gateway" -ConnectionBroker $RDServer -GatewayExternalFqdn $ExtRDG
Write-Host "done" -ForegroundColor green