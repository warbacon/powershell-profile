# My PowerShell profile

## Dependencies

### Git

If you don't have it installed on your system, you can do it using winget:

```sh
winget install --id Git.Git -e --source winget
```

Or by going to <https://git-scm.com/download/win>.

### Starship (optional)

```sh
winget install starship
```

### Eza (optional)

The easiest way to install it is to use [scoop](scoop.sh).

You can install scoop using:

```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
irm get.scoop.sh | iex
```

And then install eza using:

```sh
scoop install eza
```

## Installation

```sh
git clone https://github.com/Warbacon/powershell-profile.git "$HOME\Documents\Powershell"
```
