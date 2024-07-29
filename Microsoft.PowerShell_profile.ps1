# UTILITY ---------------------------------------------------------------------
function Test-Command {
    param (
        [Parameter(Position=0,mandatory=$true)]
        [string]$Command
    )
    return [bool](Get-Command $Command -ErrorAction SilentlyContinue)
}

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

# APPEARANCE ------------------------------------------------------------------
$PSStyle.FileInfo.Directory = "$($PSStyle.Bold)$($PSStyle.Foreground.Blue)"
Set-PSReadLineOption -Colors @{
    Parameter        = "Blue"
    Operator         = "Blue"
    InlinePrediction = "DarkGray"
}

# KEYBINDINGS -----------------------------------------------------------------
Set-PSReadLineOption -EditMode Emacs
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

    # Sets window title
    function Invoke-Starship-PreCommand {
        $Host.UI.RawUI.WindowTitle = "$pwd".Replace("$HOME", "~")
    }

    # Environmental variables
    $Env:STARSHIP_CONFIG = "$HOME\Documents\Powershell\starship.toml"
    $Env:STARSHIP_CACHE = "$HOME\AppData\Local\Temp"

    # Starts Starship
    Invoke-Expression (&starship init powershell --print-full-init | Out-String)
}

