# APPEARANCE -------------------------------------------------------------------
$PSStyle.FileInfo.Directory = "$($PSStyle.Bold)$($PSStyle.Foreground.Blue)"
Set-PSReadLineOption -Colors @{
    Parameter        = "Blue"
    Operator         = "Blue"
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
function where {
    Param([Parameter(Mandatory = $true)] [String]$cmd)
    return (Get-Command $cmd).Source
}
Set-Alias -Name touch -Value New-Item

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

# OH-MY-POSH -------------------------------------------------------------------
try {
    oh-my-posh init pwsh --config "$HOME/Documents/Powershell/zunder.omp.json" | Invoke-Expression
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
