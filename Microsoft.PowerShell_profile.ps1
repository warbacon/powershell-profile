#Requires -Version 7
# VARIABLES -------------------------------------------------------------------
$PROFILE_DIR = Split-Path -Path $PROFILE
$CACHE_DIR = if ($IsWindows) {
    "$HOME\AppData\Local\Temp"
}
else {
    "$HOME/.cache"
}
$WT_CONFIG = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"

# UTILITY FUNCTIONS -----------------------------------------------------------
function Test-CommandExists {
    [CmdletBinding()]
    [OutputType([bool])]
    param (
        [Parameter(Position = 0, Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Command
    )
    [bool](Get-Command $Command -ErrorAction SilentlyContinue)
}

function New-CachedScript {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$Name,
        [Parameter(Mandatory)]
        [string]$CacheSubDir,
        [Parameter(Mandatory)]
        [scriptblock]$Generator
    )

    $cacheDir = Join-Path $CACHE_DIR $CacheSubDir
    $scriptPath = Join-Path $cacheDir "Start-$Name.ps1"

    if (-not (Test-Path $scriptPath)) {
        New-Item -ItemType Directory -Force $cacheDir | Out-Null
        & $Generator | Out-File -FilePath $scriptPath -Encoding utf8
    }

    . $scriptPath
}

# Set default editor
$env:EDITOR = @(
    @( 'nvim' ),
    @('zed', '--wait'),
    @('code', '--wait'),
    @( 'nano' )
    @( 'vim' )
    @( 'vi' )
) | Where-Object { Test-CommandExists $_[0] } | Select-Object -First 1

# Get public IP (uses ipify.org API)
function Get-PubIP {
    (Invoke-RestMethod -Uri 'https://api.ipify.org?format=json').ip
}

# APPEARANCE ------------------------------------------------------------------
$PSStyle.FileInfo.Directory = $PSStyle.Bold + $PSStyle.Foreground.Blue
Set-PSReadLineOption -Colors @{
    Default          = $PSStyle.Reset
    InlinePrediction = $PSStyle.Italic + $PSStyle.Foreground.BrightBlack
    Operator         = $PSStyle.Reset
    Parameter        = $PSStyle.Reset
};

# LS_COLORS (dircolors compatible)
$env:LS_COLORS = 'rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=00:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.7z=01;31:*.ace=01;31:*.alz=01;31:*.apk=01;31:*.arc=01;31:*.arj=01;31:*.bz=01;31:*.bz2=01;31:*.cab=01;31:*.cpio=01;31:*.crate=01;31:*.deb=01;31:*.drpm=01;31:*.dwm=01;31:*.dz=01;31:*.ear=01;31:*.egg=01;31:*.esd=01;31:*.gz=01;31:*.jar=01;31:*.lha=01;31:*.lrz=01;31:*.lz=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.lzo=01;31:*.pyz=01;31:*.rar=01;31:*.rpm=01;31:*.rz=01;31:*.sar=01;31:*.swm=01;31:*.t7z=01;31:*.tar=01;31:*.taz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tgz=01;31:*.tlz=01;31:*.txz=01;31:*.tz=01;31:*.tzo=01;31:*.tzst=01;31:*.udeb=01;31:*.war=01;31:*.whl=01;31:*.wim=01;31:*.xz=01;31:*.z=01;31:*.zip=01;31:*.zoo=01;31:*.zst=01;31:*.avif=01;35:*.jpg=01;35:*.jpeg=01;35:*.jxl=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.webp=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:*~=00;90:*#=00;90:*.bak=00;90:*.crdownload=00;90:*.dpkg-dist=00;90:*.dpkg-new=00;90:*.dpkg-old=00;90:*.dpkg-tmp=00;90:*.old=00;90:*.orig=00;90:*.part=00;90:*.rej=00;90:*.rpmnew=00;90:*.rpmorig=00;90:*.rpmsave=00;90:*.swp=00;90:*.tmp=00;90:*.ucf-dist=00;90:*.ucf-new=00;90:*.ucf-old=00;90:'

# FZF theme
$env:FZF_DEFAULT_OPTS = @(
    '--highlight-line',
    '--color=fg:#cdcbdd',
    '--color=bg:#181624',
    '--color=gutter:#181624',
    '--color=border:#52abcf',
    '--color=separator:#52abcf',
    '--color=scrollbar:#625f7e',
    '--color=hl:#e97294',
    '--color=hl+:#e97294',
    '--color=fg+:#cdcbdd',
    '--color=bg+:#2b3b51',
    '--color=pointer:#e9b5b3',
    '--color=prompt:#e9b5b3',
    '--color=spinner:#e9b5b3',
    '--color=marker:#e9b5b3',
    '--color=header:#52abcf',
    '--color=info:#8e8aac',
    '--color=preview-border:#52abcf',
    '--color=preview-scrollbar:#625f7e'
) -join ' '

# ALIASES & FUNCTIONS ---------------------------------------------------------
Set-Alias -Name which -Value where.exe

# LazyGit alias
if (Test-CommandExists lazygit) {
    Set-Alias -Name lg -Value lazygit
}

# Coreutils
if (Test-CommandExists rm.exe) {
    Set-Alias -Name rm -Value rm.exe
}
if (Test-CommandExists cp.exe) {
    Remove-Alias cp
    Set-Alias -Name cp -Value cp.exe
}
if (Test-CommandExists mv.exe) {
    Remove-Alias mv
    Set-Alias -Name mv -Value mv.exe -Force
}
if (Test-CommandExists mkdir.exe) {
    Set-Alias -Name mkdir -Value mkdir.exe -Force
}
if (Test-CommandExists ls.exe) {
    Remove-Alias ls
    function ls() {
        ls.exe --color --group-directories-first -vF $args
    }
    function ll() {
        ls.exe --color --group-directories-first -vFlh $args
    }
    function la() {
        ls.exe --color --group-directories-first -vFlhA $args
    }
}

# Interactive directory navigation with fzf
function cdf {
    $excludeDirs = @(
        '.affinity',
        '.bun',
        '.cache',
        '.dotnet',
        '.git',
        '.gradle',
        '.nuget',
        '.vscode',
        'go',
        'node_modules',
        'scoop',
        'vendor'
    )

    $fzfArgs = @(
        '--height=50%',
        '--cycle',
        '--prompt=Go to> ',
        '--scheme=path',
        '--layout=reverse',
        '--walker=dir,hidden',
        "--walker-skip=$($excludeDirs -join ',')"
    )

    $dir = & fzf @fzfArgs
    if ($LASTEXITCODE -eq 0 -and $dir) {
        Set-Location -LiteralPath $dir
    }
}

# KEYBINDINGS -----------------------------------------------------------------
Set-PSReadLineOption -EditMode Emacs -HistorySearchCursorMovesToEnd

$keybindings = @{
    'Alt+e'           = 'ViEditVisually'
    'Ctrl+w'          = 'BackwardDeleteWord'
    'Ctrl+Backspace'  = 'BackwardDeleteWord'
    'Alt+LeftArrow'   = 'BackwardWord'
    'Alt+RightArrow'  = 'ForwardWord'
    'Ctrl+LeftArrow'  = 'BackwardWord'
    'Ctrl+RightArrow' = 'ForwardWord'
    'DownArrow'       = 'HistorySearchForward'
    'UpArrow'         = 'HistorySearchBackward'
    'Tab'             = 'MenuComplete'
}

$keybindings.GetEnumerator() | ForEach-Object {
    Set-PSReadLineKeyHandler -Chord $_.Key -Function $_.Value
}

# Alt+c for quick directory change
Set-PSReadLineKeyHandler -Chord Alt+c -ScriptBlock {
    [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert('cdf')
    [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
}

# SCOOP-SEARCH INTEGRATION ----------------------------------------------------
if (Test-CommandExists scoop) {
    if (-not (Test-CommandExists scoop-search)) {
        scoop install scoop-search
    }

    function scoop {
        if ($args[0] -eq 'search') {
            scoop-search.exe @($args | Select-Object -Skip 1)
        }
        else {
            scoop.ps1 @args
        }
    }
}

# STARSHIP PROMPT -------------------------------------------------------------
if (Test-CommandExists starship) {
    function Invoke-Starship-PreCommand {
        # Set window title
        $Host.UI.RawUI.WindowTitle = $PWD.Path.Replace($HOME, '~')

        # Add newline only when needed
        if ($Host.UI.RawUI.CursorPosition.Y -ne 0) {
            Write-Host
        }

        # Windows Terminal tab/pane duplication support
        if ($env:WT_SESSION) {
            $loc = $executionContext.SessionState.Path.CurrentLocation
            $prompt = "`e]9;12`a"
            if ($loc.Provider.Name -eq 'FileSystem') {
                $prompt += "`e]9;9;`"$($loc.ProviderPath)`"`e\"
            }
            $Host.UI.Write($prompt)
        }
    }

    $env:STARSHIP_CONFIG = Join-Path $PROFILE_DIR 'starship.toml'
    $env:STARSHIP_CACHE = Join-Path $CACHE_DIR 'starship'

    New-CachedScript -Name 'Starship' -CacheSubDir 'starship' -Generator {
        starship init powershell --print-full-init
    }
}
