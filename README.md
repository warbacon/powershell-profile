# My PowerShell 7 profile 🗣️

This was made exclusively for Windows and [PowerShell
7](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows),
**not Windows PowerShell.**

If you want to use this on Linux or MacOS, *you are weird*, but you can make
this work if you have the dependencies I specify below for your operating
system and change some paths made for Windows within the profile.

## Dependencies

``git`` is used to clone the repository

```sh
winget install Git.Git
```

and ``starship`` is used as prompt, though is *optional*.

```sh
winget install Starship.Starship
```

## Installation

Just clone this repository as your Powershell 7 profile:

```sh
git clone https://github.com/Warbacon/powershell-profile.git "$HOME\Documents\Powershell"
```
