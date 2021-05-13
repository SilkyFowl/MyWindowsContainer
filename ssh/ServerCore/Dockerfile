# escape=`

ARG TAG=20H2

FROM core:${TAG}

SHELL ["pwsh", "-command"]

# Install win32-openssh
RUN scoop install -g win32-openssh;

# Create a user to login, as containeradministrator password is unknown
RUN net USER ssh "Passw0rd" /ADD && net localgroup "Administrators" "ssh" /ADD;

# Config ssh
RUN New-Item -Path HKLM:\SOFTWARE -Name OpenSSH -Force; `
    Set-ItemProperty HKLM:\SOFTWARE\OpenSSH\ -Name DefaultShell -Value (Get-Command pwsh).Source -Force; `
    $PSNativeCommandArgumentPassing = 'Legacy'; `
    C:\ProgramData\scoop\apps\win32-openssh\current\install-sshd.ps1;  `
    C:\ProgramData\scoop\apps\win32-openssh\current\FixHostFilePermissions.ps1 -Confirm:$false; `
    Get-Service ssh* | Set-Service -StartupType Automatic;

EXPOSE 22

# Start ssh service.
CMD [ "pwsh", "-sshs" ]