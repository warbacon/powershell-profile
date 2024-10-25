using namespace System.Management.Automation
using namespace System.Management.Automation.Language

Register-ArgumentCompleter -Native -CommandName 'starship' -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)

    $commandElements = $commandAst.CommandElements
    $command = @(
        'starship'
        for ($i = 1; $i -lt $commandElements.Count; $i++) {
            $element = $commandElements[$i]
            if ($element -isnot [StringConstantExpressionAst] -or
                $element.StringConstantType -ne [StringConstantType]::BareWord -or
                $element.Value.StartsWith('-') -or
                $element.Value -eq $wordToComplete) {
                break
        }
        $element.Value
    }) -join ';'

    $completions = @(switch ($command) {
        'starship' {
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('-V', '-V ', [CompletionResultType]::ParameterName, 'Print version')
            [CompletionResult]::new('--version', '--version', [CompletionResultType]::ParameterName, 'Print version')
            [CompletionResult]::new('bug-report', 'bug-report', [CompletionResultType]::ParameterValue, 'Create a pre-populated GitHub issue with information about your configuration')
            [CompletionResult]::new('completions', 'completions', [CompletionResultType]::ParameterValue, 'Generate starship shell completions for your shell to stdout')
            [CompletionResult]::new('config', 'config', [CompletionResultType]::ParameterValue, 'Edit the starship configuration')
            [CompletionResult]::new('explain', 'explain', [CompletionResultType]::ParameterValue, 'Explains the currently showing modules')
            [CompletionResult]::new('init', 'init', [CompletionResultType]::ParameterValue, 'Prints the shell function used to execute starship')
            [CompletionResult]::new('module', 'module', [CompletionResultType]::ParameterValue, 'Prints a specific prompt module')
            [CompletionResult]::new('preset', 'preset', [CompletionResultType]::ParameterValue, 'Prints a preset config')
            [CompletionResult]::new('print-config', 'print-config', [CompletionResultType]::ParameterValue, 'Prints the computed starship configuration')
            [CompletionResult]::new('prompt', 'prompt', [CompletionResultType]::ParameterValue, 'Prints the full starship prompt')
            [CompletionResult]::new('session', 'session', [CompletionResultType]::ParameterValue, 'Generate random session key')
            [CompletionResult]::new('time', 'time', [CompletionResultType]::ParameterValue, 'Prints time in milliseconds')
            [CompletionResult]::new('timings', 'timings', [CompletionResultType]::ParameterValue, 'Prints timings of all active modules')
            [CompletionResult]::new('toggle', 'toggle', [CompletionResultType]::ParameterValue, 'Toggle a given starship module')
            [CompletionResult]::new('help', 'help', [CompletionResultType]::ParameterValue, 'Print this message or the help of the given subcommand(s)')
            break
        }
        'starship;bug-report' {
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'starship;completions' {
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'starship;config' {
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'starship;explain' {
            [CompletionResult]::new('-s', '-s', [CompletionResultType]::ParameterName, 'The status code of the previously run command as an unsigned or signed 32bit integer')
            [CompletionResult]::new('--status', '--status', [CompletionResultType]::ParameterName, 'The status code of the previously run command as an unsigned or signed 32bit integer')
            [CompletionResult]::new('--pipestatus', '--pipestatus', [CompletionResultType]::ParameterName, 'Bash, Fish and Zsh support returning codes for each process in a pipeline')
            [CompletionResult]::new('-w', '-w', [CompletionResultType]::ParameterName, 'The width of the current interactive terminal')
            [CompletionResult]::new('--terminal-width', '--terminal-width', [CompletionResultType]::ParameterName, 'The width of the current interactive terminal')
            [CompletionResult]::new('-p', '-p', [CompletionResultType]::ParameterName, 'The path that the prompt should render for')
            [CompletionResult]::new('--path', '--path', [CompletionResultType]::ParameterName, 'The path that the prompt should render for')
            [CompletionResult]::new('-P', '-P ', [CompletionResultType]::ParameterName, 'The logical path that the prompt should render for. This path should be a virtual/logical representation of the PATH argument')
            [CompletionResult]::new('--logical-path', '--logical-path', [CompletionResultType]::ParameterName, 'The logical path that the prompt should render for. This path should be a virtual/logical representation of the PATH argument')
            [CompletionResult]::new('-d', '-d', [CompletionResultType]::ParameterName, 'The execution duration of the last command, in milliseconds')
            [CompletionResult]::new('--cmd-duration', '--cmd-duration', [CompletionResultType]::ParameterName, 'The execution duration of the last command, in milliseconds')
            [CompletionResult]::new('-k', '-k', [CompletionResultType]::ParameterName, 'The keymap of fish/zsh/cmd')
            [CompletionResult]::new('--keymap', '--keymap', [CompletionResultType]::ParameterName, 'The keymap of fish/zsh/cmd')
            [CompletionResult]::new('-j', '-j', [CompletionResultType]::ParameterName, 'The number of currently running jobs')
            [CompletionResult]::new('--jobs', '--jobs', [CompletionResultType]::ParameterName, 'The number of currently running jobs')
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'starship;init' {
            [CompletionResult]::new('--print-full-init', '--print-full-init', [CompletionResultType]::ParameterName, 'print-full-init')
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'starship;module' {
            [CompletionResult]::new('-s', '-s', [CompletionResultType]::ParameterName, 'The status code of the previously run command as an unsigned or signed 32bit integer')
            [CompletionResult]::new('--status', '--status', [CompletionResultType]::ParameterName, 'The status code of the previously run command as an unsigned or signed 32bit integer')
            [CompletionResult]::new('--pipestatus', '--pipestatus', [CompletionResultType]::ParameterName, 'Bash, Fish and Zsh support returning codes for each process in a pipeline')
            [CompletionResult]::new('-w', '-w', [CompletionResultType]::ParameterName, 'The width of the current interactive terminal')
            [CompletionResult]::new('--terminal-width', '--terminal-width', [CompletionResultType]::ParameterName, 'The width of the current interactive terminal')
            [CompletionResult]::new('-p', '-p', [CompletionResultType]::ParameterName, 'The path that the prompt should render for')
            [CompletionResult]::new('--path', '--path', [CompletionResultType]::ParameterName, 'The path that the prompt should render for')
            [CompletionResult]::new('-P', '-P ', [CompletionResultType]::ParameterName, 'The logical path that the prompt should render for. This path should be a virtual/logical representation of the PATH argument')
            [CompletionResult]::new('--logical-path', '--logical-path', [CompletionResultType]::ParameterName, 'The logical path that the prompt should render for. This path should be a virtual/logical representation of the PATH argument')
            [CompletionResult]::new('-d', '-d', [CompletionResultType]::ParameterName, 'The execution duration of the last command, in milliseconds')
            [CompletionResult]::new('--cmd-duration', '--cmd-duration', [CompletionResultType]::ParameterName, 'The execution duration of the last command, in milliseconds')
            [CompletionResult]::new('-k', '-k', [CompletionResultType]::ParameterName, 'The keymap of fish/zsh/cmd')
            [CompletionResult]::new('--keymap', '--keymap', [CompletionResultType]::ParameterName, 'The keymap of fish/zsh/cmd')
            [CompletionResult]::new('-j', '-j', [CompletionResultType]::ParameterName, 'The number of currently running jobs')
            [CompletionResult]::new('--jobs', '--jobs', [CompletionResultType]::ParameterName, 'The number of currently running jobs')
            [CompletionResult]::new('-l', '-l', [CompletionResultType]::ParameterName, 'List out all supported modules')
            [CompletionResult]::new('--list', '--list', [CompletionResultType]::ParameterName, 'List out all supported modules')
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'starship;preset' {
            [CompletionResult]::new('-o', '-o', [CompletionResultType]::ParameterName, 'Output the preset to a file instead of stdout')
            [CompletionResult]::new('--output', '--output', [CompletionResultType]::ParameterName, 'Output the preset to a file instead of stdout')
            [CompletionResult]::new('-l', '-l', [CompletionResultType]::ParameterName, 'List out all preset names')
            [CompletionResult]::new('--list', '--list', [CompletionResultType]::ParameterName, 'List out all preset names')
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'starship;print-config' {
            [CompletionResult]::new('-d', '-d', [CompletionResultType]::ParameterName, 'Print the default instead of the computed config')
            [CompletionResult]::new('--default', '--default', [CompletionResultType]::ParameterName, 'Print the default instead of the computed config')
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'starship;prompt' {
            [CompletionResult]::new('--profile', '--profile', [CompletionResultType]::ParameterName, 'Print the prompt with the specified profile name (instead of the standard left prompt)')
            [CompletionResult]::new('-s', '-s', [CompletionResultType]::ParameterName, 'The status code of the previously run command as an unsigned or signed 32bit integer')
            [CompletionResult]::new('--status', '--status', [CompletionResultType]::ParameterName, 'The status code of the previously run command as an unsigned or signed 32bit integer')
            [CompletionResult]::new('--pipestatus', '--pipestatus', [CompletionResultType]::ParameterName, 'Bash, Fish and Zsh support returning codes for each process in a pipeline')
            [CompletionResult]::new('-w', '-w', [CompletionResultType]::ParameterName, 'The width of the current interactive terminal')
            [CompletionResult]::new('--terminal-width', '--terminal-width', [CompletionResultType]::ParameterName, 'The width of the current interactive terminal')
            [CompletionResult]::new('-p', '-p', [CompletionResultType]::ParameterName, 'The path that the prompt should render for')
            [CompletionResult]::new('--path', '--path', [CompletionResultType]::ParameterName, 'The path that the prompt should render for')
            [CompletionResult]::new('-P', '-P ', [CompletionResultType]::ParameterName, 'The logical path that the prompt should render for. This path should be a virtual/logical representation of the PATH argument')
            [CompletionResult]::new('--logical-path', '--logical-path', [CompletionResultType]::ParameterName, 'The logical path that the prompt should render for. This path should be a virtual/logical representation of the PATH argument')
            [CompletionResult]::new('-d', '-d', [CompletionResultType]::ParameterName, 'The execution duration of the last command, in milliseconds')
            [CompletionResult]::new('--cmd-duration', '--cmd-duration', [CompletionResultType]::ParameterName, 'The execution duration of the last command, in milliseconds')
            [CompletionResult]::new('-k', '-k', [CompletionResultType]::ParameterName, 'The keymap of fish/zsh/cmd')
            [CompletionResult]::new('--keymap', '--keymap', [CompletionResultType]::ParameterName, 'The keymap of fish/zsh/cmd')
            [CompletionResult]::new('-j', '-j', [CompletionResultType]::ParameterName, 'The number of currently running jobs')
            [CompletionResult]::new('--jobs', '--jobs', [CompletionResultType]::ParameterName, 'The number of currently running jobs')
            [CompletionResult]::new('--right', '--right', [CompletionResultType]::ParameterName, 'Print the right prompt (instead of the standard left prompt)')
            [CompletionResult]::new('--continuation', '--continuation', [CompletionResultType]::ParameterName, 'Print the continuation prompt (instead of the standard left prompt)')
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'starship;session' {
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'starship;time' {
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'starship;timings' {
            [CompletionResult]::new('-s', '-s', [CompletionResultType]::ParameterName, 'The status code of the previously run command as an unsigned or signed 32bit integer')
            [CompletionResult]::new('--status', '--status', [CompletionResultType]::ParameterName, 'The status code of the previously run command as an unsigned or signed 32bit integer')
            [CompletionResult]::new('--pipestatus', '--pipestatus', [CompletionResultType]::ParameterName, 'Bash, Fish and Zsh support returning codes for each process in a pipeline')
            [CompletionResult]::new('-w', '-w', [CompletionResultType]::ParameterName, 'The width of the current interactive terminal')
            [CompletionResult]::new('--terminal-width', '--terminal-width', [CompletionResultType]::ParameterName, 'The width of the current interactive terminal')
            [CompletionResult]::new('-p', '-p', [CompletionResultType]::ParameterName, 'The path that the prompt should render for')
            [CompletionResult]::new('--path', '--path', [CompletionResultType]::ParameterName, 'The path that the prompt should render for')
            [CompletionResult]::new('-P', '-P ', [CompletionResultType]::ParameterName, 'The logical path that the prompt should render for. This path should be a virtual/logical representation of the PATH argument')
            [CompletionResult]::new('--logical-path', '--logical-path', [CompletionResultType]::ParameterName, 'The logical path that the prompt should render for. This path should be a virtual/logical representation of the PATH argument')
            [CompletionResult]::new('-d', '-d', [CompletionResultType]::ParameterName, 'The execution duration of the last command, in milliseconds')
            [CompletionResult]::new('--cmd-duration', '--cmd-duration', [CompletionResultType]::ParameterName, 'The execution duration of the last command, in milliseconds')
            [CompletionResult]::new('-k', '-k', [CompletionResultType]::ParameterName, 'The keymap of fish/zsh/cmd')
            [CompletionResult]::new('--keymap', '--keymap', [CompletionResultType]::ParameterName, 'The keymap of fish/zsh/cmd')
            [CompletionResult]::new('-j', '-j', [CompletionResultType]::ParameterName, 'The number of currently running jobs')
            [CompletionResult]::new('--jobs', '--jobs', [CompletionResultType]::ParameterName, 'The number of currently running jobs')
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'starship;toggle' {
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'starship;help' {
            [CompletionResult]::new('bug-report', 'bug-report', [CompletionResultType]::ParameterValue, 'Create a pre-populated GitHub issue with information about your configuration')
            [CompletionResult]::new('completions', 'completions', [CompletionResultType]::ParameterValue, 'Generate starship shell completions for your shell to stdout')
            [CompletionResult]::new('config', 'config', [CompletionResultType]::ParameterValue, 'Edit the starship configuration')
            [CompletionResult]::new('explain', 'explain', [CompletionResultType]::ParameterValue, 'Explains the currently showing modules')
            [CompletionResult]::new('init', 'init', [CompletionResultType]::ParameterValue, 'Prints the shell function used to execute starship')
            [CompletionResult]::new('module', 'module', [CompletionResultType]::ParameterValue, 'Prints a specific prompt module')
            [CompletionResult]::new('preset', 'preset', [CompletionResultType]::ParameterValue, 'Prints a preset config')
            [CompletionResult]::new('print-config', 'print-config', [CompletionResultType]::ParameterValue, 'Prints the computed starship configuration')
            [CompletionResult]::new('prompt', 'prompt', [CompletionResultType]::ParameterValue, 'Prints the full starship prompt')
            [CompletionResult]::new('session', 'session', [CompletionResultType]::ParameterValue, 'Generate random session key')
            [CompletionResult]::new('time', 'time', [CompletionResultType]::ParameterValue, 'Prints time in milliseconds')
            [CompletionResult]::new('timings', 'timings', [CompletionResultType]::ParameterValue, 'Prints timings of all active modules')
            [CompletionResult]::new('toggle', 'toggle', [CompletionResultType]::ParameterValue, 'Toggle a given starship module')
            [CompletionResult]::new('help', 'help', [CompletionResultType]::ParameterValue, 'Print this message or the help of the given subcommand(s)')
            break
        }
        'starship;help;bug-report' {
            break
        }
        'starship;help;completions' {
            break
        }
        'starship;help;config' {
            break
        }
        'starship;help;explain' {
            break
        }
        'starship;help;init' {
            break
        }
        'starship;help;module' {
            break
        }
        'starship;help;preset' {
            break
        }
        'starship;help;print-config' {
            break
        }
        'starship;help;prompt' {
            break
        }
        'starship;help;session' {
            break
        }
        'starship;help;time' {
            break
        }
        'starship;help;timings' {
            break
        }
        'starship;help;toggle' {
            break
        }
        'starship;help;help' {
            break
        }
    })

    $completions.Where{ $_.CompletionText -like "$wordToComplete*" } |
        Sort-Object -Property ListItemText
}

# Create a new dynamic module so we don't pollute the global namespace with our functions and
# variables
$null = New-Module starship {
    function Get-Cwd {
        $cwd = Get-Location
        $provider_prefix = "$($cwd.Provider.ModuleName)\$($cwd.Provider.Name)::"
        return @{
            # Resolve the actual/physical path
            # NOTE: ProviderPath is only a physical filesystem path for the "FileSystem" provider
            # E.g. `Dev:\` -> `C:\Users\Joe Bloggs\Dev\`
            Path = $cwd.ProviderPath;
            # Resolve the provider-logical path
            # NOTE: Attempt to trim any "provider prefix" from the path string.
            # E.g. `Microsoft.PowerShell.Core\FileSystem::Dev:\` -> `Dev:\`
            LogicalPath =
                if ($cwd.Path.StartsWith($provider_prefix)) {
                    $cwd.Path.Substring($provider_prefix.Length)
                } else {
                    $cwd.Path
                };
        }
    }

    function Invoke-Native {
        param($Executable, $Arguments)
        $startInfo = New-Object System.Diagnostics.ProcessStartInfo -ArgumentList $Executable -Property @{
            StandardOutputEncoding = [System.Text.Encoding]::UTF8;
            RedirectStandardOutput = $true;
            RedirectStandardError = $true;
            CreateNoWindow = $true;
            UseShellExecute = $false;
        };
        if ($startInfo.ArgumentList.Add) {
            # PowerShell 6+ uses .NET 5+ and supports the ArgumentList property
            # which bypasses the need for manually escaping the argument list into
            # a command string.
            foreach ($arg in $Arguments) {
                $startInfo.ArgumentList.Add($arg);
            }
        }
        else {
            # Build an arguments string which follows the C++ command-line argument quoting rules
            # See: https://docs.microsoft.com/en-us/previous-versions//17w5ykft(v=vs.85)?redirectedfrom=MSDN
            $escaped = $Arguments | ForEach-Object {
                $s = $_ -Replace '(\\+)"','$1$1"'; # Escape backslash chains immediately preceding quote marks.
                $s = $s -Replace '(\\+)$','$1$1';  # Escape backslash chains immediately preceding the end of the string.
                $s = $s -Replace '"','\"';         # Escape quote marks.
                "`"$s`""                           # Quote the argument.
            }
            $startInfo.Arguments = $escaped -Join ' ';
        }
        $process = [System.Diagnostics.Process]::Start($startInfo)

        # Read the output and error streams asynchronously
        # Avoids potential deadlocks when the child process fills one of the buffers
        # https://docs.microsoft.com/en-us/dotnet/api/system.diagnostics.process.standardoutput?view=net-6.0#remarks
        $stdout = $process.StandardOutput.ReadToEndAsync()
        $stderr = $process.StandardError.ReadToEndAsync()
        [System.Threading.Tasks.Task]::WaitAll(@($stdout, $stderr))

        # stderr isn't displayed with this style of invocation
        # Manually write it to console
        if ($stderr.Result.Trim() -ne '') {
            # Write-Error doesn't work here
            $host.ui.WriteErrorLine($stderr.Result)
        }

        $stdout.Result;
    }

    function Enable-TransientPrompt {
        Set-PSReadLineKeyHandler -Key Enter -ScriptBlock {
            $previousOutputEncoding = [Console]::OutputEncoding
            try {
                $parseErrors = $null
                [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$null, [ref]$null, [ref]$parseErrors, [ref]$null)
                if ($parseErrors.Count -eq 0) {
                    $script:TransientPrompt = $true
                    [Console]::OutputEncoding = [Text.Encoding]::UTF8
                    [Microsoft.PowerShell.PSConsoleReadLine]::InvokePrompt()
                }
            } finally {
                if ($script:DoesUseLists) {
                    # If PSReadline is set to display suggestion list, this workaround is needed to clear the buffer below
                    # before accepting the current commandline. The max amount of items in the list is 10, so 12 lines
                    # are cleared (10 + 1 more for the prompt + 1 more for current commandline).
                    [Microsoft.PowerShell.PSConsoleReadLine]::Insert("`n" * [math]::Min($Host.UI.RawUI.WindowSize.Height - $Host.UI.RawUI.CursorPosition.Y - 1, 12))
                    [Microsoft.PowerShell.PSConsoleReadLine]::Undo()
                }
                [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
                [Console]::OutputEncoding = $previousOutputEncoding
            }
        }
    }

    function Disable-TransientPrompt {
        Set-PSReadLineKeyHandler -Key Enter -Function AcceptLine
        $script:TransientPrompt = $false
    }

    function global:prompt {
        $origDollarQuestion = $global:?
        $origLastExitCode = $global:LASTEXITCODE

        # Invoke precmd, if specified
        try {
            if (Test-Path function:Invoke-Starship-PreCommand) {
                Invoke-Starship-PreCommand
            }
        } catch {}

        # @ makes sure the result is an array even if single or no values are returned
        $jobs = @(Get-Job | Where-Object { $_.State -eq 'Running' }).Count

        $cwd = Get-Cwd
        $arguments = @(
            "prompt"
            "--path=$($cwd.Path)",
            "--logical-path=$($cwd.LogicalPath)",
            "--terminal-width=$($Host.UI.RawUI.WindowSize.Width)",
            "--jobs=$($jobs)"
        )

        # We start from the premise that the command executed correctly, which covers also the fresh console.
        $lastExitCodeForPrompt = 0
        if ($lastCmd = Get-History -Count 1) {
            # In case we have a False on the Dollar hook, we know there's an error.
            if (-not $origDollarQuestion) {
                # We retrieve the InvocationInfo from the most recent error using $global:error[0]
                $lastCmdletError = try { $global:error[0] |  Where-Object { $_ -ne $null } | Select-Object -ExpandProperty InvocationInfo } catch { $null }
                # We check if the last command executed matches the line that caused the last error, in which case we know
                # it was an internal Powershell command, otherwise, there MUST be an error code.
                $lastExitCodeForPrompt = if ($null -ne $lastCmdletError -and $lastCmd.CommandLine -eq $lastCmdletError.Line) { 1 } else { $origLastExitCode }
            }
            $duration = [math]::Round(($lastCmd.EndExecutionTime - $lastCmd.StartExecutionTime).TotalMilliseconds)

            $arguments += "--cmd-duration=$($duration)"
        }

        $arguments += "--status=$($lastExitCodeForPrompt)"

        if ([Microsoft.PowerShell.PSConsoleReadLine]::InViCommandMode()) {
            $arguments += "--keymap=vi"
        }

        # Invoke Starship
        $promptText = if ($script:TransientPrompt) {
            $script:TransientPrompt = $false
            if (Test-Path function:Invoke-Starship-TransientFunction) {
                Invoke-Starship-TransientFunction
            } else {
                "$([char]0x1B)[1;32m❯$([char]0x1B)[0m "
            }
        } else {
            Invoke-Native -Executable 'C:\Program Files\starship\bin\starship.exe' -Arguments $arguments
        }

        # Set the number of extra lines in the prompt for PSReadLine prompt redraw.
        Set-PSReadLineOption -ExtraPromptLineCount ($promptText.Split("`n").Length - 1)

        # Return the prompt
        $promptText

        # Propagate the original $LASTEXITCODE from before the prompt function was invoked.
        $global:LASTEXITCODE = $origLastExitCode

        # Propagate the original $? automatic variable value from before the prompt function was invoked.
        #
        # $? is a read-only or constant variable so we can't directly override it.
        # In order to propagate up its original boolean value we will take an action
        # which will produce the desired value.
        #
        # This has to be the very last thing that happens in the prompt function
        # since every PowerShell command sets the $? variable.
        if ($global:? -ne $origDollarQuestion) {
            if ($origDollarQuestion) {
                 # Simple command which will execute successfully and set $? = True without any other side affects.
                1+1
            } else {
                # Write-Error will set $? to False.
                # ErrorAction Ignore will prevent the error from being added to the $Error collection.
                Write-Error '' -ErrorAction 'Ignore'
            }
        }

    }

    # Disable virtualenv prompt, it breaks starship
    $ENV:VIRTUAL_ENV_DISABLE_PROMPT=1

    $script:TransientPrompt = $false
    $script:DoesUseLists = (Get-PSReadLineOption).PredictionViewStyle -eq 'ListView'

    if ($PSVersionTable.PSVersion.Major -gt 5) {
        $ENV:STARSHIP_SHELL = "pwsh"
    } else {
        $ENV:STARSHIP_SHELL = "powershell"
    }

    # Set up the session key that will be used to store logs
    $ENV:STARSHIP_SESSION_KEY = -join ((48..57) + (65..90) + (97..122) | Get-Random -Count 16 | ForEach-Object { [char]$_ })

    # Invoke Starship and set continuation prompt
    Set-PSReadLineOption -ContinuationPrompt (
        Invoke-Native -Executable 'C:\Program Files\starship\bin\starship.exe' -Arguments @(
            "prompt",
            "--continuation"
        )
    )

    try {
        Set-PSReadLineOption -ViModeIndicator script -ViModeChangeHandler {
            [Microsoft.PowerShell.PSConsoleReadLine]::InvokePrompt()
        }
    } catch {}

    Export-ModuleMember -Function @(
        "Enable-TransientPrompt"
        "Disable-TransientPrompt"
    )
}

