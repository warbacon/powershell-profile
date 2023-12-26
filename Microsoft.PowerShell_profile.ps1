# APPEARANCE -------------------------------------------------------------------
$PSStyle.FileInfo.Directory = "$($PSStyle.Bold)$($PSstyle.Foreground.Blue)"

# PSREADLINE -------------------------------------------------------------------
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

# ALIASES ----------------------------------------------------------------------
Set-Alias -Name touch -Value New-Item
Set-Alias -Name ex -Value explorer.exe
function .. { Set-Location .. }

# NEOVIM CURSOR FIX ------------------------------------------------------------
if (Get-Command -ErrorAction SilentlyContinue -Name "nvim.exe") {
    function nvim {
        nvim.exe $args
        [Console]::Write("`e[0 q")
    }
}

# PROMPT -----------------------------------------------------------------------
$ErrorActionPreference = 'SilentlyContinue'
$OMP_THEME = "$HOME\Documents\Powershell\thundership.omp.json"
oh-my-posh init pwsh --config $OMP_THEME | Invoke-Expression
$ErrorActionPreference = 'Continue'