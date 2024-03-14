# dotfiles
Repo to quickly get started on new machines with my favorite configs

## Supported programs

### alacritty
Mostly the default alacritty config with my iterm2 styles

### tmux
Configured to use the following plugins:
'tmux-plugins/tmux-sensible'
'tmux-plugins/tmux-resurrect'
'tmux-plugins/tmux-continuum'

### vim
Uses vim plug, has only nerdcommenter installed

### neovim
For my neovim config I used kickstart([`https://github.com/nvim-lua/kickstart.nvim`](https://github.com/nvim-lua/kickstart.nvim)) as a starting point
I have made modifications and added the following plugins in addition to what comes with kickstart:
- copilot([`https://github.com/github/copilot.vim`](https://github.com/github/copilot.vim))
- CopilotChat([`https://github.com/gptlang/CopilotChat.nvim`](https://github.com/gptlang/CopilotChat.nvim))

## Planned development:

- have 3 dotfile options:
    - dotfiles (for main workstations, completely set up a main device)
    - dotfiles-light (for machines with a little more constraints due to hardware limitaions i.e. raspberry pi, other SBCs)
    - dotfiles-headless (for headless machines)
- make scripts POSIX compliant

## Scripts

### install script
This install script will ask to install:
- alacritty
- git
- zsh
- neofetch
- tmux
- vim
- neovim

Alacritty and neovim installation varies widely from OS and architecture, so it is not guaranteed that the install script will work for all systems

The programs will be needed to use these dotfiles and their plugins

Should work with:
- Linux (Debian/Ubuntu based)
- OsX
- Termux on Android

> [!WARNING]  
> It is dangerous to download random scripts from the internet without understanding them, proceed with caution
```sh
curl -O https://raw.githubusercontent.com/EnocFlores/dotfiles/main/install.sh
chmod +x install.sh
./install.sh
rm install.sh
```

### update script
Once this repository is downloaded, you can run this script to update your dotfiles if there have been new updates to the remote dotfiles repository

