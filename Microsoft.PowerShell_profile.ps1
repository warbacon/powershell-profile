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

# Fastfetch alias
if (Test-CommandExists fastfetch) {
    Set-Alias -Name ff -Value fastfetch
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
        # if ($Host.UI.RawUI.CursorPosition.Y -ne 0) {
        #     Write-Host
        # }

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

# DO NOT MODIFY -- coreutils -- 60b36fc6-2d59-49df-be51-28dd2f4c3c9a
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
# Inlining the template into the profile shaves off ~10ms (25%).
$script:__COREUTILS__ = [System.Collections.Generic.HashSet[string]]::new(
    [string[]]@('arch','b2sum','base32','base64','basename','basenc','cat','cksum','comm','cp','csplit','cut','date','df','dirname','du','echo','env','expr','factor','false','find','fmt','fold','grep','head','hostname','join','la','link','ln','ls','md5sum','mkdir','mktemp','mv','nl','nproc','numfmt','od','paste','pathchk','pr','printenv','printf','ptx','pwd','readlink','realpath','rm','rmdir','seq','sha1sum','sha224sum','sha256sum','sha384sum','sha512sum','shuf','sleep','sort','split','stat','sum','tac','tail','tee','test','touch','tr','true','truncate','tsort','unexpand','uniq','unlink','uptime','wc','xargs','yes'),
    [System.StringComparer]::OrdinalIgnoreCase
)

$script:__COREUTILS_FAST_SKIP__ = [regex]::new(
    '\b(?:' + ($script:__COREUTILS__ -join '|') + ')\b',
    [System.Text.RegularExpressions.RegexOptions]::Compiled -bor `
        [System.Text.RegularExpressions.RegexOptions]::IgnoreCase
)

# Casting the scriptblock to Func<Ast,bool> once and reusing it avoids the
# per-FindAll scriptblock-to-delegate wrapping overhead (~1.7x faster).
$script:__COREUTILS_CMD_PREDICATE__ = [System.Func[System.Management.Automation.Language.Ast, bool]] {
    param($n) $n -is [System.Management.Automation.Language.CommandAst]
}

$script:__COREUTILS_ARG_SPECIAL__ = [char[]] @("'", '"', '`', '$')

# Wrap arguments into quotes. By being a function we can properly handle $variables.
# As per MSVCRT, any `\` before `"` must be doubled to escape them.
function global:__coreutils_q {
    param($s)
    '"' + (([string]$s) -replace '(\\*)"', '$1$1\"' -replace '(\\+)$', '$1$1') + '"'
}

# PowerShell tokenizes `*"a"*` as [BareWord] instead of the expected [DoubleQuoted, BareWord, DoubleQuoted].
# To work around that we use... regex. Group 1 = 'single', 2 = "double", 3 = `escape, 4 = bare run.
$script:__COREUTILS_ARG_RX__ = [regex]::new(
    "'((?:[^']|'')*)'|""((?:[^""``]|""""|``.)*)""|``(.)|([^'""``]+)",
    [System.Text.RegularExpressions.RegexOptions]::Compiled
)
$script:__COREUTILS_ARG_EVAL__ = [System.Text.RegularExpressions.MatchEvaluator] {
    param($m)
    if ($m.Groups[1].Success) {
        # Single-quoted: literal. PS '' -> ', then MSVCRT-quote.
        $body = $m.Groups[1].Value.Replace("''", "'")
        if ($body -match '^(.*?)(\\+)$') {
            return '"' + ($matches[1] -replace '(\\*)"', '$1$1\"') + '"' + $matches[2]
        }
        return '"' + ($body -replace '(\\*)"', '$1$1\"') + '"'
    }
    if ($m.Groups[2].Success) {
        # Double-quoted: collapse PS quote-escapes to raw " / ', let ExpandString
        # resolve `n / `t / $var, then MSVCRT-quote.
        $body = $m.Groups[2].Value.
        Replace('`"', '"').
        Replace("``'", "'").
        Replace('""', '"')
        $body = $ExecutionContext.InvokeCommand.ExpandString($body)
        if ($body -match '^(.*?)(\\+)$') {
            return '"' + ($matches[1] -replace '(\\*)"', '$1$1\"') + '"' + $matches[2]
        }
        return '"' + ($body -replace '(\\*)"', '$1$1\"') + '"'
    }
    if ($m.Groups[3].Success) {
        # Backtick-escaped char outside a string: " -> \"; everything else
        # becomes a one-char quoted region so glob metas stay literal.
        $c = $m.Groups[3].Value
        if ($c -eq '"') {
            return '\"'
        }
        return '"' + $c + '"'
    }
    # Bare run: passed through unquoted so coreutils can glob it; expand $vars.
    return $ExecutionContext.InvokeCommand.ExpandString($m.Groups[4].Value)
}

# 0: not tested, 1: coreutils not installed, 2: coreutils installed.
$script:__COREUTILS_CMD_DIR_TEST__ = 0

# PSConsoleHostReadLine override that rewrites coreutils command names to their
# .cmd equivalents after PSReadLine returns (history keeps the original).
#
# Why .cmd over .exe: PSNativeCommandArgumentPassing = 'Windows' results in a behavior
# where passing bare quotes to CreateProcess() is impossible. This prevents us from
# passing "*" as "*" to coreutils and instead will be given as a bare *.
# This causes it to treat it as a glob pattern. "*.cmd" files however are automatically
# treated as PSNativeCommandArgumentPassing = 'Legacy', which preserves quotes.
# It is the only possible workaround and the only way coreutils can work at all.
function PSConsoleHostReadLine {
    [System.Diagnostics.DebuggerHidden()]
    param()

    $lastRunStatus = $?
    Microsoft.PowerShell.Core\Set-StrictMode -Off
    $line = [Microsoft.PowerShell.PSConsoleReadLine]::ReadLine($host.Runspace, $ExecutionContext, $lastRunStatus)

    # If the line contains no coreutils name, we don't need to parse the AST at all.
    if (-not $script:__COREUTILS_FAST_SKIP__.IsMatch($line)) {
        return $line
    }

    # Roamed/synced profiles can load this snippet on machines where coreutils is not installed.
    # Test for the existence of the command directory once and remember the result.
    if ($script:__COREUTILS_CMD_DIR_TEST__ -eq 0) {
        $script:__COREUTILS_CMD_DIR_TEST__ = 1
        if (Test-Path -LiteralPath 'C:\Program Files\coreutils\cmd\' -PathType Container -ErrorAction Ignore) {
            $script:__COREUTILS_CMD_DIR_TEST__ = 2
        }
    }
    if ($script:__COREUTILS_CMD_DIR_TEST__ -ne 2) {
        return $line
    }

    $ast = [System.Management.Automation.Language.Parser]::ParseInput($line, [ref]$null, [ref]$null)
    $commands = $ast.FindAll($script:__COREUTILS_CMD_PREDICATE__, $true)

    # Process right-to-left so earlier offsets stay valid after each splice.
    # In-place reverse beats Sort-Object for the typical 1-command line.
    if ($commands.Count -gt 1) {
        $commands = [System.Collections.Generic.List[object]]::new($commands)
        $commands.Reverse()
    }

    foreach ($cmd in $commands) {
        $name = $cmd.GetCommandName()
        if (!$name) {
            continue
        }

        $baseName = $name
        if ($name.EndsWith('.exe') -or $name.EndsWith('.cmd')) {
            $baseName = $name.Substring(0, $name.Length - 4)
        }
        if (!$script:__COREUTILS__.Contains($baseName)) {
            continue
        }

        # ls/la get colour + listing flags injected; la also rewrites to ls.
        $cmdElement = $cmd.CommandElements[0]
        $start = $cmdElement.Extent.StartOffset
        $end = $cmdElement.Extent.EndOffset
        $replacement = "& 'C:\Program Files\coreutils\cmd\"

        switch ($baseName) {
            'la' {
                $replacement += "ls.cmd' --color=auto -AFhl" 
            }
            'ls' {
                $replacement += "ls.cmd' --color=auto" 
            }
            default {
                $replacement += "$baseName.cmd'" 
            }
        }

        # Walk command elements, merging adjacent ones whose extents touch
        # (e.g. `'a'*` parses as [SingleQuoted, BareWord] but is one shell word).
        # The inverse case `*'a'*` parses as a single BareWord whose text
        # contains the embedded quotes, which is why AST-only analysis
        # isn't enough and we still need to re-tokenize the source span.
        $argsStart = $end
        $argsEnd = $cmd.Extent.EndOffset
        $rewrittenArgs = ''
        $elements = $cmd.CommandElements
        $count = $elements.Count
        $i = 1
        while ($i -lt $count) {
            $first = $elements[$i]
            $wordStart = $first.Extent.StartOffset
            $wordEnd = $first.Extent.EndOffset
            $merged = $false
            while ($i + 1 -lt $count -and $elements[$i + 1].Extent.StartOffset -eq $wordEnd) {
                $i++
                $wordEnd = $elements[$i].Extent.EndOffset
                $merged = $true
            }
            $source = $line.Substring($wordStart, $wordEnd - $wordStart)
            $rewrittenArgs += $line.Substring($argsStart, $wordStart - $argsStart)
            $argsStart = $wordEnd
            # IndexOfAny beats running the regex per arg.
            if ($source.IndexOfAny($script:__COREUTILS_ARG_SPECIAL__) -lt 0) {
                $rewrittenArgs += $source
                $i++
                continue
            }
            # A single un-merged PS expression that needs $var resolution
            # (bare $var, "...$var...", $x.Member, $($expr), etc.).
            # Defer evaluation to runtime so the value reaches coreutils as a literal arg.
            # This matches POSIX behaviour where variable expansions don't result in globbing.
            if (-not $merged -and
                ($first -is [System.Management.Automation.Language.VariableExpressionAst] -or
                $first -is [System.Management.Automation.Language.ExpandableStringExpressionAst] -or
                $first -is [System.Management.Automation.Language.MemberExpressionAst])) {
                $rewrittenArgs += '(__coreutils_q ' + $source + ')'
                $i++
                continue
            }
            # Slow path: re-tokenise and re-emit as MSVCRT-style quoting,
            # then wrap in PS single quotes so PS hands the body verbatim.
            $windowsQuoted = $script:__COREUTILS_ARG_RX__.Replace($source, $script:__COREUTILS_ARG_EVAL__)
            $rewrittenArgs += "'" + $windowsQuoted.Replace("'", "''") + "'"
            $i++
        }
        $rewrittenArgs += $line.Substring($argsStart, $argsEnd - $argsStart)

        $line = $line.Substring(0, $start) + $replacement + $rewrittenArgs + $line.Substring($argsEnd)
    }

    return $line
}
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# DO NOT MODIFY -- coreutils -- 60b36fc6-2d59-49df-be51-28dd2f4c3c9a
