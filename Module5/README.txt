https://chocolatey.org/install


Chocolatey

Run as Administrator:
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"


MS SQL Server

choco install sql-server-2017 /Q 



Octopus

choco install octopusdeploy

choco install octopustools

choco install octopusdeploy.tentacle