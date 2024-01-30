# APPEARANCE ------------------------------------------------------------------
$PSStyle.FileInfo.Directory = "$($PSStyle.Bold)$($PSstyle.Foreground.Blue)"

# PSREADLINE ------------------------------------------------------------------
Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineKeyHandler -Key Ctrl+LeftArrow -Function BackwardWord
Set-PSReadLineKeyHandler -Key Ctrl+RightArrow -Function ForwardWord
Set-PSReadLineKeyHandler -Key Ctrl+Backspace -Function BackwardDeleteWord
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadLineOption -Colors @{
    Parameter        = "Blue"
    Operator         = "Blue"
    InlinePrediction = "DarkGray"
}

# ALIASES ---------------------------------------------------------------------
function .. { Set-Location .. }
Set-Alias -Name touch -Value New-Item
Set-Alias -Name ex -Value explorer.exe

if (Get-Command lazygit -ErrorAction SilentlyContinue) {
    Set-Alias -Name lg -Value lazygit.exe
}

# STARSHIP --------------------------------------------------------------------
if (Get-Command starship -ErrorAction SilentlyContinue) {
    function Invoke-Starship-PreCommand {
        $host.ui.Write($prompt)
        $host.ui.RawUI.WindowTitle = "$pwd".Replace("$HOME", "~")
    }

    $ENV:STARSHIP_CONFIG = "$HOME\Documents\Powershell\starship.toml"
    $ENV:STARSHIP_CACHE = "$HOME\AppData\Local\Temp"

    Invoke-Expression (&starship init powershell --print-full-init | Out-String)
}
