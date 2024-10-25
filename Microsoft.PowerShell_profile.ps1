# UTILITY ---------------------------------------------------------------------
$PROFILE_DIR = "$(Split-Path -Path $PROFILE)"

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
elseif (Test-CommandExists vim) {
    "vim"
}
elseif (Test-CommandExists code) {
    "code"
}

# Uses -> https://www.ipify.org
function Get-PubIP {
    return (Invoke-RestMethod -Uri "https://api.ipify.org?format=json").ip
}

# Source -> https://github.com/ChrisTitusTech/winutil
if ($IsWindows) {
    function winutil {
        # Define the command to execute
        $command = 'Invoke-RestMethod "https://christitus.com/win" | Invoke-Expression'

        # Check if the script is being run as an administrator
        if (-not ([Security.Principal.WindowsPrincipal] `
                    [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
                    [Security.Principal.WindowsBuiltInRole] "Administrator")) {

            # Launch the script with administrator privileges
            if (Test-CommandExists "wt.exe") {
                # Use Windows Terminal if installed
                Start-Process wt.exe -ArgumentList "pwsh.exe -Command `"$command`"" -Verb RunAs
            }
            else {
                Start-Process pwsh.exe -ArgumentList "-Command `"$command`"" -Verb RunAs
            }
        }
        else {
            # Execute the command directly if already running as administrator
            Invoke-Expression $command
        }
    }
}

# APPEARANCE ------------------------------------------------------------------
$PSStyle.FileInfo.Directory = "$($PSStyle.Bold)$($PSStyle.Foreground.Blue)"
Set-PSReadLineOption -Colors @{
    Default          = "$($PSStyle.Reset)"
    InlinePrediction = "`e[90;3m"
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
if (Test-CommandExists "scoop") {
    if (-not (Test-CommandExists "scoop-search")) {
        scoop install scoop-search
    }
    Invoke-Expression (&scoop-search --hook)
}

# STARSHIP --------------------------------------------------------------------
if (Test-CommandExists "starship") {

    function Invoke-Starship-PreCommand {
        # Set the window title
        $Host.UI.RawUI.WindowTitle = $PWD.Path.Replace("$HOME", "~")

        # Add a newline when needed
        if ($Host.UI.RawUI.CursorPosition.Y -ne 0) {
            Write-Host
        }

        # Enable tab/pane duplication in Windows Terminal
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
    $env:STARSHIP_CONFIG = "$PROFILE_DIR/starship.toml"
    if ($IsWindows) {
        $env:STARSHIP_CACHE = "$HOME/AppData/Local/Temp"
    }

    # Start Starship
    . "$PROFILE_DIR/Start-Starship.ps1"
}
