# UTILITY ---------------------------------------------------------------------
function Test-Command {
    param (
        [Parameter(Position=0,mandatory=$true)]
        [string]$Command
    )
    return [bool](Get-Command $Command -ErrorAction SilentlyContinue)
}

# Uses -> https://www.ipify.org
function Get-PublicIP {
    try {
        $ip = Invoke-RestMethod -Uri "https://api.ipify.org?format=json"
        return $ip.ip
    }
    catch {
        Write-Error "Failed to retrieve the public IP address: $_"
        return $null
    }
}

# Source -> https://github.com/ChrisTitusTech/winutil
function Invoke-Winutil {
    Invoke-RestMethod "https://christitus.com/win" | Invoke-Expression
}

# APPEARANCE ------------------------------------------------------------------
$PSStyle.FileInfo.Directory = "$($PSStyle.Bold)$($PSStyle.Foreground.Blue)"
Set-PSReadLineOption -Colors @{
    Parameter        = "Blue"
    Operator         = "Blue"
    InlinePrediction = "DarkGray"
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
function .. {
    Set-Location ..
}
Set-Alias -Name touch -Value New-Item

if (Test-Command "lazygit.exe") {
    Set-Alias -Name lg -Value lazygit.exe
}

if (Test-Command "scoop") {
    Invoke-Expression (&scoop-search --hook)
}

# STARSHIP --------------------------------------------------------------------
if (Test-Command "starship.exe") {

    function Invoke-Starship-PreCommand {
        # Sets window title
        $Host.UI.RawUI.WindowTitle = $PWD.Path.Replace("$HOME", "~")

        # Enables tab/pane duplication
        $loc = $executionContext.SessionState.Path.CurrentLocation;
        $prompt = "$([char]27)]9;12$([char]7)"
        if ($loc.Provider.Name -eq "FileSystem") {
            $prompt += "$([char]27)]9;9;`"$($loc.ProviderPath)`"$([char]27)\"
        }
        $host.ui.Write($prompt)
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

