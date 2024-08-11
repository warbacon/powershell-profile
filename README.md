# My PowerShell 7 profile 🗣️

This was made exclusively for [PowerShell
7](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows),
**not Windows PowerShell.**

**This is intended to be used on Windows**, although if you want to use this on
Linux or macOS, *you are weird*, but you can make this work if you have the
dependencies I specify below for your operating system.

> [!TIP]
> It is recommended to use version 7.4 or later to take advantage of
> experimental features.

## ⚙️ Dependencies

`git` is used to clone the repository

```sh
winget install Git.Git
```

and `starship` is used as prompt, though it's *optional*.

```sh
winget install Starship.Starship
```

## 🚀 Installation

Just clone this repository as your PowerShell 7 profile like this if you are in
Windows:

```sh
git clone https://github.com/Warbacon/powershell-profile.git "$HOME\Documents\PowerShell"
```

Or use this if you are on Linux or macOS:

```sh
git clone https://github.com/Warbacon/powershell-profile.git "$HOME/.config/powershell"
```
