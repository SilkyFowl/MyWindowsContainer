function gcim {
    switch ($args[0]) {
        "win32_process" {
            ps | Add-Member AliasProperty -Name processid -Value Id -PassThru |
            Add-Member ScriptProperty -Name parentprocessid -Value { $this.Parent.Id } -PassThru
        }
        "Win32_OperatingSystem" {
            [PSCustomObject]@{
                Version = $PSVersionTable.os -replace '\w+\s\w+\s'
            }
        }
    }
}


$ExecutionContext.SessionState.InvokeCommand.PreCommandLookupAction = {
    [System.Management.Automation.CommandLookupEventArgs]$cl = $_
    if ($cl.CommandName -eq 'al_') {
        $cl.CommandScriptBlock = {
            $s = i_
            if (Test-Path $log) {
                del $log
            }

            $ab_ = $sDir -replace ' ', '` '
            ak_
            $argsStr = "--start-server --host=127.0.0.1 --enable-remote-auto-shutdown --port=0 --connection-secret '$ai_' $q_ $exts *> '$log'"

            "Refactor: Starting server: '$sDir\server.cmd' $argsStr"
            $psi=[System.Diagnostics.ProcessStartInfo]@{
                FileName="pwsh.exe";
                Arguments="-ExecutionPolicy Unrestricted -NoLogo -NoProfile -NonInteractive -c $ab_\server.cmd $args"
                WindowStyle="Hidden";
                CreateNoWindow=$true;
                UseShellExecute=$false;
                WorkingDirectory=$ab_;
            }

            $global:v_ = [System.Diagnostics.Process]::Start($psi).Id
            $s.Stop()
            $global:m_ = $s.ElapsedMilliseconds
        }
    }
}