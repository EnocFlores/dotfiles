# dotfiles
> Repo to quickly get started on new machines with my favorite configs

---

## Supported programs

### zsh
My personal prompt: user@machine, parent folder, and git branch
Several aliases and functions

#### Installation
| OS/Device | Method |
| --- | --- |
| Debian/Ubuntu | `package manager: apt` |
| OsX | `package manager: brew` |
| Termux | `package manager: pkg` |

### neofetch
Used by zsh config on first system startup and before running tmux or zellij

#### Installation
| OS/Device | Method |
| --- | --- |
| Debian/Ubuntu | `package manager: apt` |
| OsX | `package manager: brew` |
| Termux | `package manager: pkg` |

### vim
My personal vim config, uses vim-plug as a plugin manager
Plugins:
- preservim/nerdcommenter

#### Installation
| OS/Device | Method |
| --- | --- |
| Debian/Ubuntu | `package manager: apt` |
| OsX | `package manager: brew` |
| Termux | `package manager: pkg` |

### btop
A prettier htop, I use it to monitor system resources
I do have a config to make it more compact

#### Installation
| OS/Device | Method |
| --- | --- |
| Debian/Ubuntu | `package manager: apt` |
| OsX | `package manager: brew` |
| Termux | `TBA` |

### tmux
Very customized to myself, I use tpm as a plugin manager
Plugins:
- tmux-plugins/tmux-sensible
- tmux-plugins/tmux-resurrect
- tmux-plugins/tmux-continuum

#### Installation
| OS/Device | Method |
| --- | --- |
| Debian/Ubuntu | `package manager: apt` |
| OsX | `package manager: brew` |
| Termux | `package manager: pkg` |

### neovim
For my neovim config I used kickstart([`https://github.com/nvim-lua/kickstart.nvim`](https://github.com/nvim-lua/kickstart.nvim)) as a starting point
I have made modifications and added the following plugins in addition to what comes with kickstart:
- copilot([`https://github.com/github/copilot.vim`](https://github.com/github/copilot.vim))
- CopilotChat([`https://github.com/gptlang/CopilotChat.nvim`](https://github.com/gptlang/CopilotChat.nvim))

#### Installation
| OS/Device | Method |
| --- | --- |
| Debian/Ubuntu x86 | `appimage` |
| Debian/Ubuntu arm | `build from source` |
| OsX | `package manager: brew` |
| Termux | `package manager: pkg` |

### lf
A pretty nice file manager that I use when viewing images on my system withing the terminal with chafa and wezterm

#### Installation
| OS/Device | Method |
| --- | --- |
| Debian/Ubuntu | `prebuilt binary` |
| OsX | `package manager: brew` |
| Termux | `package manager: pkg` |

### chafa
A terminal image viewer, I use it with lf and wezterm

#### Installation
| OS/Device | Method |
| --- | --- |
| Debian/Ubuntu | `package manager: apt` |
| OsX | `package manager: brew` |
| Termux | `package manager: pkg` |

### alacritty
Mostly the default alacritty config with my iterm2 styles, keep it here because of its fast and lightweight nature

#### Installation
| OS/Device | Method |
| --- | --- |
| Debian/Ubuntu | `package manager: apt` |
| OsX | `package manager: brew` |
| Termux | `N/A` |

### zellij
Tried zellij, ended up really liking it alot, not sure if I will be removng tmux completely just becuase there are still things I like about it better, but maybe one day zellij will replace it

#### Installation
| OS/Device | Method |
| --- | --- |
| Debian/Ubuntu | `prebuilt binary` |
| OsX | `package manager: brew` |
| Termux | `package manager: pkg` |

### wezterm
My new main terminal emulator, allows me to see images

#### Installation
| OS/Device | Method |
| --- | --- |
| Debian/Ubuntu | `build from source` |
| OsX | `package manager: brew` |
| Termux | `N/A` |

---

## Planned development:

- have 3 dotfile options:
    - dotfiles (for main workstations, completely set up a new main device)
    - dotfiles-light (for machines with a little more constraints due to hardware limitaions i.e. raspberry pi, other SBCs)
    - dotfiles-headless (for headless machines)
- make scripts POSIX compliant

---

## Scripts

### Compatibility
Should work with:
- Linux (Debian/Ubuntu based)
- OsX
- Termux on Android

### install script
This install script will ask to install:
- git
- zsh
- neofetch
- vim
- btop
- tmux
- alacritty
- neovim
- lf
- chafa
- zellij
- wezterm

Alacritty and neovim installation varies widely from OS and architecture, so it is not guaranteed that the install script will work for all systems

The programs will be needed to use these dotfiles and their plugins

> [!WARNING]  
> It is dangerous to download random scripts from the internet without understanding them, proceed with caution
```sh
curl -O https://raw.githubusercontent.com/EnocFlores/dotfiles/main/install.sh
chmod +x install.sh
./install.sh
rm install.sh
```

### update script
Once this repository is downloaded, cd into it and you can run this script to update your dotfiles if there have been new updates to the remote dotfiles repository

## Contributing

Do not request programs to be added to the install script, this is a personal repository and I will not add programs that I do not use, please fork it and make it your own. However, I do welcome any suggestions to try out any programs or configuration changes. If you have a better way of doing something, or if you find any errors please open a pull request. 
