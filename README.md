# My PowerShell 7 profile 🗣️

This was made exclusively for [PowerShell
7](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows),
**not Windows PowerShell.**

> [!NOTE]
> This profile is intended for use on Windows. Although it also works correctly
> on Linux and macOS, it is not optimized for them at the moment.

## 🚀 Features

- Bash-like keyboard shortcuts.
- Improved syntax highlighting colors.
- Nice, simple and fast prompt. Uses [Starship](https://starship.rs).
- Windows Terminal integration for tab and pane duplication.
- Enables some useful experimental powershell features.
- Includes a few useful aliases.
- And some other smaller goodies!

### Enabled experimental features

> [!NOTE]
> You need to use version 7.4 or later to take advantage of experimental
> features.

- **PSCommandNotFoundSuggestion:** Recommend potential commands based on fuzzy
search on a CommandNotFoundException.
- **PSFeedbackProvider:** Replace the hard-coded suggestion framework with the
extensible feedback provider.

## 💊 Optional dependencies

- `starship` is used as prompt when it's installed. Refer to its [installation
guide](https://starship.rs/guide/#%F0%9F%9A%80-installation).

- `carapace` provides completions of for a large number of commands if it's
installed. You can use `winget install -e --id rsteube.Carapace` to install it.

## 🪛 Installation

Just clone this repository as your PowerShell 7 profile like this if you are in
Windows:

```sh
git clone https://github.com/Warbacon/powershell-profile.git "$HOME\Documents\PowerShell"
```

Or use this if you are on Linux or macOS:

```sh
git clone https://github.com/Warbacon/powershell-profile.git "$HOME/.config/powershell"
```
