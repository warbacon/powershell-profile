# UTILITIES --------------------------------------------------------------------
function Test-CommandExists {
    param ($command)
    if (Get-Command $command -ErrorAction SilentlyContinue) {
        return $true
    } else {
        return $false
    }
}

function Get-PublicIP {
    (Invoke-WebRequest http://ifconfig.me/ip).Content
}

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
Set-Alias -Name touch -Value New-Item
Set-Alias -Name which -Value Get-Command

# NEOVIM CURSOR FIX ------------------------------------------------------------
if (Test-CommandExists nvim) {
    $nvimPath = (Get-Command nvim).Source
    function nvim {
        & $nvimPath $args
        [Console]::Write("`e[0 q")
    }
}

# PROMPT -----------------------------------------------------------------------
if ((Test-CommandExists oh-my-posh)) {
    ## START OH-MY-POSH
    oh-my-posh init pwsh --config "$HOME/Documents/Powershell/zunder.omp.json" | Invoke-Expression
} else {
    ## SIMPLE AND FAST PROMPT
    function prompt {
        $success = $Global:?

        $currentPath = $PWD.Path
        if ($currentPath.StartsWith($HOME)) {
            $currentPath = "~" + $currentPath.Substring($HOME.Length)
        }
        $Host.UI.RawUI.WindowTitle = $currentPath

        $prompt += "`n"
        $prompt += "$($PSStyle.Bold)$($PSStyle.Foreground.Cyan)$currentPath$($PSStyle.Reset)"
        $prompt += "`n"

        if ($success) {
            $prompt += "$($PSStyle.Foreground.Green)❯"
        } else {
            $prompt += "$($PSStyle.Foreground.Red)❯"
        }
        $prompt += "$($PSStyle.Reset) "

        return $prompt
    }
}
