# dotfiles
Repo to quickly get started on new machines with my favorite configs

## Suported programs

### alacritty
I used the default alacritty config and slowly moved over my iterm2 styles, just recently transitioned so have only made very basic changes

### neovim
For my neovim config I used kickstart([`https://github.com/nvim-lua/kickstart.nvim`](`https://github.com/nvim-lua/kickstart.nvim`)) as a starting point
I have made modifications and added the following plugins in addition to what comes with kickstart:
    copilot([`https://github.com/github/copilot.vim`](`https://github.com/github/copilot.vim`))
    CopilotChat([`https://github.com/gptlang/CopilotChat.nvim`](`https://github.com/gptlang/CopilotChat.nvim`))

## Scripts

### install script
This install script will ask to install:
- alacritty
- git
- zsh
- tmux
- vim
- neovim

This install script will attempt to install neovim, which installation can vary widly from OS and architecture

The programs will be needed to use these dotfiles and their plugins

Should work with:
- Linux (Debian/Ubuntu based)
- OsX
- Termux on Andriod

```sh
curl -o- https://raw.githubusercontent.com/EnocFlores/dotfiles/main/install.sh | bash
```

### update script
Once this repository is downloaded you can run this script to update your dotfiles if there have been new updates to the remote dotfiles repository

