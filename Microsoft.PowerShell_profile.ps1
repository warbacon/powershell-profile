# APPEARANCE ------------------------------------------------------------------
$PSStyle.FileInfo.Directory = "$($PSStyle.Bold)$($PSstyle.Foreground.Blue)"
Set-PSReadLineOption -Colors @{
    Parameter        = "Blue"
    Operator         = "Blue"
    InlinePrediction = "`e[90;3m"
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
Set-Alias -Name ex -Value explorer.exe

if (Get-Command lazygit.exe -ErrorAction SilentlyContinue) {
    Set-Alias -Name lg -Value lazygit.exe
}

# STARSHIP --------------------------------------------------------------------
# Do nothing if Starship isn't available.
if (Get-Command starship.exe -ErrorAction SilentlyContinue) {

    # Set window title
    function Invoke-Starship-PreCommand {
        $Host.UI.RawUI.WindowTitle = "$pwd".Replace("$HOME", "~")
    }

    # Enviromental variables
    $Env:STARSHIP_CONFIG = "$HOME\Documents\Powershell\starship.toml"
    $Env:STARSHIP_CACHE = "$HOME\AppData\Local\Temp"

    # Start Starship
    Invoke-Expression (&starship init powershell --print-full-init | Out-String)
}
