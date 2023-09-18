# KEYBINDINGS ------------------------------------------------------------------
Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineKeyHandler -Key Ctrl+LeftArrow -Function BackwardWord
Set-PSReadLineKeyHandler -Key Ctrl+RightArrow -Function ForwardWord
Set-PSReadLineKeyHandler -Key Ctrl+Backspace -Function BackwardDeleteWord
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete

# ALIASES ----------------------------------------------------------------------
function .. { Set-Location .. }
function ex { explorer.exe . }

if (Get-Command -Name "fastfetch" -ErrorAction SilentlyContinue) {
    Set-Alias ffetch fastfetch
}

if (Get-Command -Name "eza" -ErrorAction SilentlyContinue) {
    del alias:ls
    function ls { eza --icons --group-directories-first $args }
    function ll { ls -lh --git }
    function la { ls -a }
    function lla { ls -lha --git }
} else {
    $PSStyle.FileInfo.Directory="$($PSStyle.Bold)$($PSStyle.Foreground.Blue)"
}

# NEOVIM CURSOR FIX ------------------------------------------------------------
if (Get-Command -Name "nvim" -ErrorAction SilentlyContinue) {
    $nvimPath = (Get-Command nvim).Source
    function nvim {
        & $nvimPath $args
        [Console]::Write("`e[0 q")
    }
}

# PROMPT -----------------------------------------------------------------------
if (Get-Command -Name "starship" -ErrorAction SilentlyContinue) {

    ## CONFIGURE AND START STARSHIP
    $ENV:STARSHIP_CONFIG = "$HOME/Documents/PowerShell/starship.toml"
    Invoke-Expression (&starship init powershell)

    function Invoke-Starship-PreCommand {
        if ($PWD.Path.StartsWith($HOME)) {
            $host.ui.RawUI.WindowTitle = "~$($PWD.Path.Substring($HOME.Length))"
        } else {
            $host.ui.RawUI.WindowTitle = "$PWD.Path"
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
