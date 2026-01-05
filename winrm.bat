@echo off
if "%1%" == "precustomization" (
    echo Do precustomization tasks
    
    REM Create a self-signed certificate for WinRM
    powershell -Command "New-SelfSignedCertificate -CertStoreLocation Cert:\LocalMachine\My -Subject 'CN=WinRM' -KeyAlgorithm RSA -KeyLength 2048 -NotAfter (Get-Date).AddYears(5) -FriendlyName 'WinRM Cert'"
    
    REM Bind the certificate to WinRM
    powershell -Command "winrm create winrm/config/Listener?Address=*+Transport=HTTPS @{Hostname='localhost';CertificateThumbprint=(Get-ChildItem -Path Cert:\LocalMachine\My | Where-Object { $_.Subject -like '*WinRM*' }).Thumbprint}"

    echo Self-signed certificate created and WinRM configured.
)