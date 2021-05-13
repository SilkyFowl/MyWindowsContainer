# escape=`

ARG WindowsNanoServerRepo=mcr.microsoft.com/windows/nanoserver
ARG CORETAG=20H2
ARG TAG=20H2

# Reference
# https://github.com/PowerShell/PowerShell-Docker/blob/master/release/lts/windowsservercore20H2/docker/Dockerfile
FROM core:${CORETAG} as installer-env

# Install win32-openssh
RUN scoop install -g win32-openssh;

FROM ${WindowsNanoServerRepo}:${TAG}

USER ContainerAdministrator

# Copy PowerShell Core from the installer container
ENV ProgramFiles="C:\Program Files" `
    # set a fixed location for the Module analysis cache
    PSModuleAnalysisCachePath="C:\Users\Public\AppData\Local\Microsoft\Windows\PowerShell\docker\ModuleAnalysisCache" `
    # Persist %PSCORE% ENV variable for user convenience
    PSCORE="$ProgramFiles\PowerShell\pwsh.exe" `
    POWERSHELL_TELEMETRY_OPTOUT="1"

# Copy PowerShell Core from the installer container
COPY --from=installer-env ["$ProgramFiles\\PowerShell\\latest", "$ProgramFiles\\PowerShell\\latest"]

# Copy Scoop Apps from the installer container
COPY --from=installer-env ["C:\\ProgramData\\scoop", "C:\\ProgramData\\scoop"]
# Copy vcruntime140.dll
COPY --from=installer-env ["C:\\Windows\\System32\\vcruntime140.dll", "C:\\Windows\\System32\\vcruntime140.dll"]

# Set the path
RUN setx /M PATH "%ProgramFiles%\PowerShell\latest;C:\ProgramData\scoop\shims;%PATH%"

SHELL ["pwsh", "-command"]

# intialize powershell module cache
RUN $stopTime = (get-date).AddMinutes(15); `
    $ErrorActionPreference = 'Stop' ; `
    $ProgressPreference = 'SilentlyContinue' ; `
    while(!(Test-Path -Path $env:PSModuleAnalysisCachePath)) {  `
      Write-Host "'Waiting for $env:PSModuleAnalysisCachePath'" ; `
      if((get-date) -gt $stopTime) { throw 'timout expired'} `
      Start-Sleep -Seconds 6; `
    } 

# Create a user to login, as containeradministrator password is unknown
RUN net USER ssh "Passw0rd" /ADD && net localgroup "Administrators" "ssh" /ADD; `
    # sshd setting
    $PSNativeCommandArgumentPassing = 'Legacy'; `
    .\ProgramData\scoop\apps\win32-openssh\current\install-sshd.ps1 `
    .\ProgramData\scoop\apps\win32-openssh\current\FixHostFilePermissions.ps1 -Confirm:$false; `
    New-Item -Path HKLM:\SOFTWARE -Name OpenSSH -Force; `
    Set-ItemProperty HKLM:\SOFTWARE\OpenSSH\ -Name DefaultShell -Value (Get-Command pwsh).Source -Type String -Force; `
    Get-Service ssh* | Set-Service -StartupType Automatic;

COPY profile.ps1 "C:\profile.ps1"
RUN Move-Item C:\profile.ps1 "$env:ProgramFiles\PowerShell\latest\profile.ps1"; `
    cd $pshome; `
    ni -it SymbolicLink -Path powershell.exe -Target .\pwsh.exe; `
    cd -;

EXPOSE 22

# re-enable telemetry
ENV POWERSHELL_TELEMETRY_OPTOUT="0"

# Start ssh service.
CMD [ "pwsh", "-sshs" ]