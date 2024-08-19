# UTILITY ---------------------------------------------------------------------
function Test-CommandExists {
    param (
        [Parameter(Position=0,mandatory=$true)]
        [string]$Command
    )
    return [bool](Get-Command $Command -ErrorAction SilentlyContinue)
}

$env:EDITOR = if (Test-CommandExists nvim) {
    "nvim"
}
elseif (Test-CommandExists code) {
    "code"
}

# Uses -> https://www.ipify.org
function Get-PubIP {
    return = (Invoke-RestMethod -Uri "https://api.ipify.org?format=json").ip
}

# Source -> https://github.com/ChrisTitusTech/winutil
if ($IsWindows) {
    function winutil {
        if (-not ([Security.Principal.WindowsPrincipal] `
                    [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
                    [Security.Principal.WindowsBuiltInRole] "Administrator")) {

            # Relaunch the script with administrator privileges
            $command = 'Invoke-RestMethod "https://christitus.com/win" | Invoke-Expression'
            Start-Process wt.exe -ArgumentList "pwsh.exe -Command `"$command`"" -Verb RunAs
        }
        else {
            # Execute the command directly if already running as administrator
            Invoke-RestMethod "https://christitus.com/win" | Invoke-Expression
        }
    }
}

# APPEARANCE ------------------------------------------------------------------
$PSStyle.FileInfo.Directory = "$($PSStyle.Bold)$($PSStyle.Foreground.Blue)"
Set-PSReadLineOption -Colors @{
    Default          = "$($PSStyle.Reset)"
    InlinePrediction = "DarkGray"
    Operator         = "Blue"
    Parameter        = "Blue"
}

# KEYBINDINGS -----------------------------------------------------------------
Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineKeyHandler -Key Ctrl+w -Function BackwardDeleteWord
Set-PSReadLineKeyHandler -Key Ctrl+Backspace -Function BackwardDeleteWord
Set-PSReadLineKeyHandler -Key Ctrl+LeftArrow -Function BackwardWord
Set-PSReadLineKeyHandler -Key Ctrl+RightArrow -Function ForwardWord
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineOption -HistorySearchCursorMovesToEnd

# ALIASES ---------------------------------------------------------------------
Set-Alias -Name touch -Value New-Item

function .. {
    Set-Location ..
}

if (Test-CommandExists "lazygit") {
    Set-Alias -Name lg -Value lazygit
}

# SCOOP-SEARCH INTEGRATION ----------------------------------------------------
if ((Test-CommandExists "scoop") -and (Test-CommandExists "scoop-search")) {
    Invoke-Expression (&scoop-search --hook)
}

# STARSHIP --------------------------------------------------------------------
if (Test-CommandExists "starship") {

    function Invoke-Starship-PreCommand {
        # Sets window title
        $Host.UI.RawUI.WindowTitle = $PWD.Path.Replace("$HOME", "~")

        # Enables tab/pane duplication in Windows Terminal
        if ($env:WT_SESSION) {
            $loc = $executionContext.SessionState.Path.CurrentLocation;
            $prompt = "$([char]27)]9;12$([char]7)"
            if ($loc.Provider.Name -eq "FileSystem") {
                $prompt += "$([char]27)]9;9;`"$($loc.ProviderPath)`"$([char]27)\"
            }
            $host.ui.Write($prompt)
        }
    }

    # Environmental variables
    if ($IsWindows) {
        $env:STARSHIP_CONFIG = "$HOME\Documents\Powershell\starship.toml"
        $env:STARSHIP_CACHE = "$HOME\AppData\Local\Temp"
    }
    else {
        $env:STARSHIP_CONFIG = "$HOME/.config/powershell/starship.toml"
    }

    # Starts Starship
    Invoke-Expression (&starship init powershell --print-full-init | Out-String)
}

