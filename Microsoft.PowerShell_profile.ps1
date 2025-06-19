# UTILITY ---------------------------------------------------------------------
$PROFILE_DIR = "$(Split-Path -Path $PROFILE)"

function Test-CommandExists {
    [CmdletBinding()]
    [OutputType([bool])]
    param (
        [Parameter(Position = 0, Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Command
    )
    if (Get-Command $Command -ErrorAction SilentlyContinue) {
        Write-Output $true
    }
    else {
        Write-Output $false
    }
}

$env:EDITOR = if (Test-CommandExists nvim) {
    "nvim"
}
elseif (Test-CommandExists vim) {
    "vim"
}
elseif (Test-CommandExists code) {
    "code"
}

# Uses -> https://www.ipify.org
function Get-PubIP {
    return (Invoke-RestMethod -Uri "https://api.ipify.org?format=json").ip
}

# APPEARANCE ------------------------------------------------------------------
$PSStyle.FileInfo.Directory = "$($PSStyle.Bold)$($PSStyle.Foreground.Blue)"
Set-PSReadLineOption -Colors @{
    Default          = "$($PSStyle.Reset)"
    InlinePrediction = "`e[90;3m"
    Operator         = "Blue"
    Parameter        = "Blue"
}

$env:FZF_DEFAULT_OPTS = @(
    '--highlight-line',
    '--info=inline-right',
    '--ansi',
    '--layout=reverse',
    '--border=none',
    '--color=bg+:#283457',
    '--color=bg:#16161e',
    '--color=border:#27a1b9',
    '--color=fg:#c0caf5',
    '--color=fg+:#c0caf5',
    '--color=gutter:#16161e',
    '--color=header:#ff9e64',
    '--color=hl+:#2ac3de',
    '--color=hl:#2ac3de',
    '--color=info:#545c7e',
    '--color=marker:#ff007c',
    '--color=pointer:#ff007c',
    '--color=prompt:#2ac3de',
    '--color=query:#c0caf5:regular',
    '--color=scrollbar:#27a1b9',
    '--color=separator:#ff9e64',
    '--color=spinner:#ff007c'
) -join ' '

# ALIASES ---------------------------------------------------------------------
Set-Alias -Name touch -Value New-Item
Set-Alias -Name unzip -Value Expand-Archive

function which {
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$ProgramName
    )

    try {
        $Command = Get-Command -Name $ProgramName -ErrorAction Stop -CommandType Application
        return $Command.Source
    }
    catch {
        Write-Error "$ProgramName is not a program."
    }
}

function .. {
    Set-Location ..
}

function cdf {
    $dir = fd --type directory -H `
        --exclude .git `
        --exclude node_modules `
        --exclude .cache `
        --exclude ".local/share/Trash" `
        --exclude .vscode `
        --exclude .npm `
        --exclude .docker `
        --exclude vendor `
    | fzf --border --layout=reverse --preview="eza --tree --color=always --level 3 --icons=always {}"

    if ($dir) {
        Set-Location $dir
    }
}

if (Test-CommandExists eza) {
    Remove-Item -Path Alias:ls

    function ls {
        eza --icons --group-directories-first $args
    }

    function ll {
        eza --icons --group-directories-first --git -lh $args
    }

    function lt {
        eza --icons --group-directories-first --git -T -L 3 $args
    }

    function la {
        eza --icons --group-directories-first -a $args
    }

    function lla {
        eza --icons --group-directories-first --git -lha $args
    }
}

if (Test-CommandExists "lazygit") {
    Set-Alias -Name lg -Value lazygit
}

function cdf {
    if (-not (Test-CommandExists "fzf") -or -not (Test-CommandExists "eza") -or -not (Test-CommandExists "fd")) {
        Write-Error "fzf, eza or fd is not installed."
        return
    }
    $dir = fd --type directory -H `
        --exclude .git `
        --exclude node_modules `
        --exclude .cache `
        --exclude ".local/share/Trash" `
        --exclude .vscode `
        --exclude .npm `
    | fzf --border --layout=reverse --preview="eza --tree --color=always --level 3 --icons=always {}"

    if ($dir) {
        Set-Location $dir
    }
}

# KEYBINDINGS -----------------------------------------------------------------
Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineKeyHandler -Key Ctrl+w -Function BackwardDeleteWord
Set-PSReadLineKeyHandler -Key Ctrl+Backspace -Function BackwardDeleteWord
Set-PSReadLineKeyHandler -Key Ctrl+LeftArrow -Function BackwardWord
Set-PSReadLineKeyHandler -Key Ctrl+RightArrow -Function ForwardWord
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadLineKeyHandler -Key Alt+c -ScriptBlock {
    [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert('cdf')
    [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
}

# SCOOP-SEARCH INTEGRATION ----------------------------------------------------
if (Test-CommandExists "scoop") {
    if (-not (Test-CommandExists "scoop-search")) {
        scoop install scoop-search
    }

    function scoop {
        if ($args[0] -eq "search") {
            scoop-search.exe @($args | Select-Object -Skip 1)
        } else {
            scoop.ps1 @args
        }
    }
}

# STARSHIP --------------------------------------------------------------------
if (Test-CommandExists "starship") {
    function Invoke-Starship-PreCommand {
        # Set the window title
        $Host.UI.RawUI.WindowTitle = $PWD.Path.Replace("$HOME", "~")

        # Add a newline when needed
        if ($Host.UI.RawUI.CursorPosition.Y -ne 0) {
            Write-Host
        }

        # Support Windows Terminal tab/pane duplication
        if ($env:WT_SESSION) {
            $current_location = $executionContext.SessionState.Path.CurrentLocation
            $prompt = "`e]9;12`a"
            if ($current_location.Provider.Name -eq "FileSystem") {
                $prompt += "`e]9;9;`"$($current_location.ProviderPath)`"`e\"
            }
            $Host.UI.Write($prompt)
        }
    }

    # Environmental variables
    $env:STARSHIP_CONFIG = "$PROFILE_DIR/starship.toml"
    if ($IsWindows) {
        $env:STARSHIP_CACHE = "$HOME\AppData\Local\Temp\starship"
    }

    # Create Starship start script if it doesn't exist
    if (-not (Test-Path -Path "$env:STARSHIP_CACHE/Start-Starship.ps1" -PathType Leaf)) {
        New-Item -ItemType Directory -Force $env:STARSHIP_CACHE | Out-Null
        starship completions power-shell >"$env:STARSHIP_CACHE/Start-Starship.ps1"
        starship init powershell --print-full-init >>"$env:STARSHIP_CACHE/Start-Starship.ps1"
    }

    # Start Starship
    . "$env:STARSHIP_CACHE/Start-Starship.ps1"
}
