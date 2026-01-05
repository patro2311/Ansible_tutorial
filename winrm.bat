@echo off

REM Enable PowerShell Remoting early
powershell -Command "Enable-PSRemoting -Force"

if "%1%" == "precustomization" (
    echo Precustomization: create WinRM certificate

    powershell -Command "New-SelfSignedCertificate -CertStoreLocation Cert:\LocalMachine\My -Subject 'CN=WinRM' -KeyAlgorithm RSA -KeyLength 2048 -NotAfter (Get-Date).AddYears(5) -FriendlyName 'WinRM Cert'"

) else if "%1%" == "postcustomization" (
    echo Postcustomization: configure WinRM HTTPS listener

    REM Create HTTPS listener using the self-signed cert
    powershell -Command "winrm create winrm/config/Listener?Address=*+Transport=HTTPS @{Hostname='localhost';CertificateThumbprint=(Get-ChildItem Cert:\LocalMachine\My | Where-Object {$_.FriendlyName -eq 'WinRM Cert'} | Select-Object -First 1 -ExpandProperty Thumbprint)}"

    echo WinRM HTTPS listener ready.
)
