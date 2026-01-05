@echo off

REM Check if the argument is "postcustomization"
if "%1%" == "postcustomization" (
    echo Do postcustomization tasks

    REM Automatically elevate to Administrator using PowerShell
    echo Elevating to Administrator...
    powershell -Command "Start-Process powershell.exe -ArgumentList '-NoProfile', '-ExecutionPolicy', 'Bypass', '-Command', ' ^
        Enable-PSRemoting -Force; ^
        $cert = New-SelfSignedCertificate -CertStoreLocation Cert:\LocalMachine\My -Subject ''CN=WinRM'' -KeyAlgorithm RSA -KeyLength 2048 -NotAfter (Get-Date).AddYears(5) -FriendlyName ''WinRM Cert''; ^
        $thumbprint = $cert.Thumbprint; ^
        winrm create winrm/config/Listener?Address=*+Transport=HTTPS @{HostName=''localhost''; CertificateThumbprint=$thumbprint}; ^
        New-NetFirewallRule -Name ''WinRM-HTTPS'' -DisplayName ''WinRM HTTPS'' -Direction Inbound -Protocol TCP -LocalPort 5986 -Action Allow; ^
        Write-Host ''WinRM HTTPS listener created successfully.'' ' -Verb RunAs"

    echo Postcustomization tasks completed.
) else (
    echo No postcustomization tasks performed.
)

exit
