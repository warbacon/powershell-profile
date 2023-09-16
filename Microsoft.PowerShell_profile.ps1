# KEYBINDINGS
Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineKeyHandler -Key Ctrl+LeftArrow -Function BackwardWord
Set-PSReadLineKeyHandler -Key Ctrl+RightArrow -Function ForwardWord
Set-PSReadLineKeyHandler -Key Ctrl+Backspace -Function BackwardDeleteWord
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete

# COLORS
$PSStyle.FileInfo.Directory="$($PSStyle.Bold)$($PSStyle.Foreground.Blue)"

# ALIASES
function .. { Set-Location .. }
function ex { explorer.exe . }

if (Get-Command -Name "fastfetch" -ErrorAction SilentlyContinue) {
    Set-Alias ffetch fastfetch
}

# NEOVIM FIX
if (Get-Command -Name "nvim" -ErrorAction SilentlyContinue) {
    $nvimPath = (Get-Command nvim).Source
    function nvim {
        & $nvimPath $args
        [Console]::Write("`e[0 q")
    }
}

# PROMPT
function prompt {
    $success = $Global:?

    $path = $Pwd.Path
    if ($path.StartsWith($HOME)) {
        $path = "~" + $path.Substring($HOME.Length)
    }
    $Host.UI.RawUI.WindowTitle = $path

    $prompt += "`n"
    $prompt += "$($PSStyle.Bold)$($PSStyle.Foreground.Cyan)$path$($PSStyle.Reset)"
    $prompt += "`n"

    if ($success) {
        $prompt += "$($PSStyle.Foreground.Green)❯"
    } else {
        $prompt += "$($PSStyle.Foreground.Red)❯"
    }
    $prompt += "$($PSStyle.Reset) "

    return $prompt
}

# STARSHIP
. "$HOME/Documents/PowerShell/Starship/Starship.ps1"
