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

if (Get-Command lazygit.exe -ErrorAction SilentlyContinue) {
    Set-Alias -Name lg -Value lazygit.exe
}

# OH-MY-POSH ------------------------------------------------------------------
if (Get-Command oh-my-posh.exe -ErrorAction SilentlyContinue) {
    $OMP_CONFIG = "~\Documents\Powershell\thundership.omp.jsonc"
    oh-my-posh init pwsh --config $OMP_CONFIG | Invoke-Expression
}
