# APPEARANCE -------------------------------------------------------------------
$PSStyle.FileInfo.Directory="$($PSStyle.Bold)$($PSStyle.Foreground.Blue)"
Set-PSReadLineOption -Colors @{
    Parameter  = "Blue"
    Operator = "Blue"
    InlinePrediction = "DarkGray"
}

# KEYBINDINGS ------------------------------------------------------------------
Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineKeyHandler -Key Ctrl+LeftArrow -Function BackwardWord
Set-PSReadLineKeyHandler -Key Ctrl+RightArrow -Function ForwardWord
Set-PSReadLineKeyHandler -Key Ctrl+Backspace -Function BackwardDeleteWord
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete

# ALIASES ----------------------------------------------------------------------
function .. { Set-Location .. }
function ex { explorer.exe . }
function which {
    Param([Parameter(Mandatory=$true)] [String]$cmd)
    return (Get-Command $cmd).Source
}
Set-Alias -Name touch -Value New-Item

# NEOVIM CURSOR FIX ------------------------------------------------------------
function nvim {
    try {
        nvim.exe $args
        [Console]::Write("`e[0 q")
    } catch {
        Write-Host "Neovim in't available."
    }
}

# OH-MY-POSH -------------------------------------------------------------------
try {
    oh-my-posh init pwsh --config "$HOME/Documents/Powershell/zunder.omp.json" | Invoke-Expression
} catch {
    Write-Host "Can't start oh-my-posh."
}
