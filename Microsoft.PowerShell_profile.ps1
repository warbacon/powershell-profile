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

# STARSHIP ---------------------------------------------------------------------
if (Get-Command starship -ErrorAction SilentlyContinue) {
    function Invoke-Starship-PreCommand {
        $loc = $executionContext.SessionState.Path.CurrentLocation
        $prompt = "$([char]27)]9;12$([char]7)"
        if ($loc.Provider.Name -eq "FileSystem") {
            $prompt += "$([char]27)]9;9;`"$($loc.ProviderPath)`"$([char]27)\"
        }
        $host.ui.Write($prompt)
        $host.ui.RawUI.WindowTitle = "$pwd".Replace("$HOME", "~")
    }

    $ENV:STARSHIP_CONFIG = "$HOME\Documents\Powershell\starship.toml"
    $ENV:STARSHIP_CACHE = "$HOME\AppData\Local\Temp"

    Invoke-Expression (&starship init powershell --print-full-init | Out-String)
}
else {
    function prompt {
        $loc = $executionContext.SessionState.Path.CurrentLocation;

        $out = ""
        if ($loc.Provider.Name -eq "FileSystem") {
            $out += "$([char]27)]9;9;`"$($loc.ProviderPath)`"$([char]27)\"
        }
        $out += "PS $loc$('>' * ($nestedPromptLevel + 1)) ";
        return $out
    }
}
