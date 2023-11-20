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
Set-PSReadLineOption -PredictionSource none
Set-PSReadLineOption -Colors @{
    Parameter        = "Blue"
    Operator         = "Blue"
    InlinePrediction = "DarkGray"
}

# ALIASES ----------------------------------------------------------------------
Set-Alias -Name touch -Value New-Item
function .. { Set-Location .. }
function ex { explorer.exe . }

# NEOVIM CURSOR FIX ------------------------------------------------------------
function nvim {
    try {
        nvim.exe $args
        [Console]::Write("`e[0 q")
    }
    catch {
        Write-Host "Neovim isn't available."
    }
}

# PROMPT -----------------------------------------------------------------------
try {
    oh-my-posh init pwsh --config "$HOME/Documents/Powershell/thundership.omp.json" | Invoke-Expression
    $env:POSH_GIT_ENABLED = $true
}
catch {
    function prompt {
        if ($?) {
            $characterColor = "$($PSStyle.Foreground.Green)"
        }
        else {
            $characterColor = "$($PSStyle.Foreground.Red)"
        }

        $character = "$characterColor`u{276f}$($PSStyle.Reset)"

        $currentDirectory = "$($PSStyle.Foreground.Cyan)" + $PWD.Path.Replace($HOME, "~") + "$($PSStyle.Reset)"

        if (Invoke-Expression "git rev-parse --is-inside-work-tree") {
            $branch = " on $($PSStyle.Foreground.Cyan)$($PSStyle.Bold)$(Invoke-Expression "git branch --show-current")$($PSStyle.Reset)"
        }

        return "`n$currentDirectory$branch`n$character "
    }
}
