# UTILITIES --------------------------------------------------------------------
function Test-CommandExists {
    Param ($command)
    $oldPreference = $ErrorActionPreference
    $ErrorActionPreference = 'SilentlyContinue'
    try { if (Get-Command $command) { RETURN $true } }
    Catch { Write-Host "$command does not exist"; RETURN $false }
    Finally { $ErrorActionPreference = $oldPreference }
}

function Get-PublicIP {
    (Invoke-WebRequest http://ifconfig.me/ip).Content
}

# APPEARANCE -------------------------------------------------------------------
$PSStyle.FileInfo.Directory="$($PSStyle.Bold)$($PSStyle.Foreground.Blue)"
Set-PSReadLineOption -Colors @{
  Parameter  = "Gray"
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

if (Test-CommandExists fastfetch) {
    Set-Alias -Name ffetch -Value fastfetch
}


# NEOVIM CURSOR FIX ------------------------------------------------------------
if (Test-CommandExists nvim) {
    $nvimPath = (Get-Command nvim).Source
    function nvim {
        & $nvimPath $args
        [Console]::Write("`e[0 q")
    }
}

# PROMPT -----------------------------------------------------------------------
if (Test-CommandExists starship) {

    ## CONFIGURE AND START STARSHIP
    $ENV:STARSHIP_CONFIG = "$HOME\Documents\PowerShell\starship.toml"
    $ENV:STARSHIP_CACHE = "$HOME\AppData\Local\Temp"

    Invoke-Expression (&starship init powershell)

    function Invoke-Starship-PreCommand {
        if ($PWD.Path.StartsWith($HOME)) {
            $host.ui.RawUI.WindowTitle = "~$($PWD.Path.Substring($HOME.Length))"
        } else {
            $host.ui.RawUI.WindowTitle = "$PWD"
        }
    }

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
