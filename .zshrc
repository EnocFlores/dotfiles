# EnocFlores <https://github.com/EnocFlores>
# Last Change: 2024.03.06



# === Important system variables ======= #
arch=$(uname -m)
os=$(uname -s)
device=$(uname -o)

PROGRAM_CHECKS=""

fpath+=${ZDOTDIR:-~}/.zsh_functions

# === Rust ============================= #
if [[ ! -d "$HOME/.cargo/bin" ]]; then
    PROGRAM_CHECKS="$PROGRAM_CHECKS\ncargo is not installed"
else
    PROGRAM_CHECKS="$PROGRAM_CHECKS\ncargo is installed"
    export PATH=$HOME/.cargo/bin:$PATH
fi

# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! #
# !!!!!!!! Brew  Specific Start !!!!!!!! #
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! #

if [ "$os" = "Darwin" ] && $(command -v brew &> /dev/null);then
    PROGRAM_CHECKS="$PROGRAM_CHECKS\nbrew is installed"
# === Add Homebrew commands to PATH  === #
    export PATH=/opt/homebrew/bin:$PATH
# ====================================== #
# === Use Homebrew version of        === #
# === openssh to fix issue of Xcode  === #
# === using an outdated version of   === #
# === the openssh command            === #
# ====================================== #
    export PATH=$(brew --prefix openssh)/bin:$PATH
elif [ "$os" = "Darwin" ]; then
    PROGRAM_CHECKS="$PROGRAM_CHECKS\nbrew is not installed"
fi

# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! #
# !!!!!!!! Brew  Specific End !!!!!!!!!! #
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! #



# === Set zsh theme ==================== #
# ZSH_THEME="~/.config/themes/wildberries.zsh-theme"
# source "~/.config/themes/wildberries.zsh-theme"

# ====================================== #
# === Enable the use of keeping      === #
# === commands from being written    === #
# === into history if space is the   === #
# === first character                === #
# ====================================== #
setopt HIST_IGNORE_SPACE

# ====================================== #
# === Share history between all your === #
# === zsh sessions, very useful if   === #
# === you use multiple terminals or  === #
# === tmux                           === #
# ====================================== #
setopt sharehistory

# ====================================== #
# === Enable if you want to ignore   === #
# === duplicate commands, useful to  === #
# === keep your history de-cluttered === #
# === from the same commands         === #
# ====================================== #
setopt histignorealldups

# ====================================== #
# === Keep 1000 lines of history     === #
# === within the scrollable shell    === #
# === history                        === #
# ====================================== #
HISTSIZE=1000

# ====================================== #
# === Save 10000 lines of history    === #
# === and store it in the            === #
# === ~/.zsh_history file            === #
# ====================================== #
SAVEHIST=10000
HISTFILE=~/.zsh_history

# === Set some env variables =========== #
export EDITOR='vim'
export VISUAL='vim'
export LS_COLORS="rs=0:di=44;36;01:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=00:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.avif=01;35:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.webp=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:*~=00;90:*#=00;90:*.bak=00;90:*.old=00;90:*.orig=00;90:*.part=00;90:*.rej=00;90:*.swp=00;90:*.tmp=00;90:*.dpkg-dist=00;90:*.dpkg-old=00;90:*.ucf-dist=00;90:*.ucf-new=00;90:*.ucf-old=00;90:*.rpmnew=00;90:*.rpmorig=00;90:*.rpmsave=00;90:"
export LSCOLORS="Gefxcxdxbxegedabagacad"

# ====================================== #
# === Show git branch names in shell === #
# === prompt                         === #
# ====================================== #
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! #
# !!! DEP. on having nerd font       !!! #
# !!! installed                      !!! #
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! #
setopt prompt_subst
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/  (\1)/'
}
if [ "$TERM" = "linux" ];then
    export PS1='%K{0}%B%F{2} %n@%m %f%b%k%K{4} %B%F{6} %1~%f%b %k%K{5}%B%F{5}$(parse_git_branch)%f%b %B%F{2}%# %k %f%b'
else
    # export PS1='%B%K{016}%F{2} %n@%m %f%k%K{017} %F{cyan} %1~%f %k%K{053}%F{201}$(parse_git_branch)%f %F{2}%#%f %k%F{053} %f%b'
    export PS1='%B%K{0}%F{2} %n@%m %f%k%K{4} %F{cyan} %1~%f %k%K{5}%F{201}$(parse_git_branch)%f %F{2}%#%f %k%b%F{5} %f'
fi
if (( $(tput cols) <= 80 )); then
    PROMPT="${PROMPT}"$'\n'
fi

# ====================================== #
# === Enable zsh advanced tab        === #
# === completion                     === #
# ====================================== #
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)

# === Enable vi mode =================== #
bindkey -v
export KEYTIMEOUT=1

# ====================================== #
# === Use vim keys in tab completion === #
# === menu                           === #
# ====================================== #
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char

# === Edit command in vim ============== #
autoload edit-command-line; zle -N edit-command-line
bindkey '^v' edit-command-line

# === Fix backspace vim bug ============ #
bindkey '^?' backward-delete-char

# ====================================== #
# === Show vim mode on right side of === #
# === prompt                         === #
# ====================================== #
function zle-line-init zle-keymap-select {
    RPS1='${${KEYMAP/vicmd/-- NORMAL --}/(main|viins)/-- INSERT --}'
    RPS2=$RPS1
    zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

# ====================================== #
# === tmux package manager check and === #
# === installation                   === #
# ====================================== #

if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
    # If it doesn't exist, ask the user if they want to install tpm
    echo "The tpm plugin is not installed. Do you want to install it now? [y/N]"
    read answer

    if [ "$answer" = "y" ]; then
        # If the user answers 'y', run the git clone command to download tpm
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    fi
else
    PROGRAM_CHECKS="$PROGRAM_CHECKS\ntpm is installed"
fi

# === Point NVM to config directory ==== #
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# ====================================== #
# === node version manager checker   === #
# === and installer                  === #
# ====================================== #
if ! command -v nvm &> /dev/null; then
    # If nvm is not installed then prompt user to install
    echo "nvm is not installed, would you like to install it? [y/N]"
    read answer

    if [ "$answer" = "y" ]; then
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    else
        PROGRAM_CHECKS="$PROGRAM_CHECKS\nnvm is not installed"
    fi
else
    PROGRAM_CHECKS="$PROGRAM_CHECKS\nnvm is installed"
fi

# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! #
# !!! place this after nvm           !!! #
# !!! initialization                 !!! #
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! #
# ====================================== #
# === Changes npm version depending  === #
# === on .nvm file (if it exists in  === #
# === current directory/repo)        === #
# ====================================== #

# === FOR LATER USE ONCE TESTED ======== #
if command -v nvm &> /dev/null; then
    autoload -U add-zsh-hook
    load-nvmrc() {
        local node_version="$(nvm version)"
        local nvmrc_path="$(nvm_find_nvmrc)"

         if [ -n "$nvmrc_path" ]; then
             local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

             if [ "$nvmrc_node_version" = "N/A" ]; then
                 nvm install
             elif [ "$nvmrc_node_version" != "$node_version" ]; then
                nvm use
            fi
        elif [ "$node_version" != "$(nvm version default)" ]; then
            echo "Reverting to nvm default version"
            nvm use default
        fi
    }
    add-zsh-hook chpwd load-nvmrc
    load-nvmrc
fi

# ====================================== #
# ============== ALIASES =============== #
# ====================================== #

# === Edit various config files ======== #
alias edita="vim ~/.zshrc"
alias editav="vim ~/.vimrc"
alias editanv="vim ~/.config/nvim/init.lua"
alias editatx="vim ~/.tmux.conf"
alias editat="vim ~/.config/alacritty/alacritty.toml"
alias editaw="vim ~/.config/wezterm/wezterm.lua"
alias editaz="vim ~/.config/zellij/config.kdl"

# === Basic aliases ==================== #
alias resource="source ~/.zshrc"
alias ls="ls --color=auto"
alias cls="clear"
alias python="python3.11"
alias diff="diff --color"
alias vims="nvim -S Session.vim"
alias icat="wezterm imgcat"
alias top="btop -p 3"
alias btop="btop -p 1"
alias tlock="tmux setw prefix None"
alias tunlock="tmux setw prefix C-t"

alias vMount='f() { cryfs $1 ~/Vaults/$(basename $1) };f'
alias vUnmount='f() { cryfs-unmount ~/Vaults/$1 };f'
# alias vList="ls -l@ ~/Vaults | grep '@' | awk '{print $NF}'"
alias vList="find ~/Vaults -type d -links 1 -maxdepth 1 | xargs -I {} basename {} | sort"



# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! #
# !!!!!!!! System Specific Start !!!!!!! #
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! #

if [ "$os" = "Linux" ]; then
    PROGRAM_CHECKS="Your OS is Linux$PROGRAM_CHECKS"
    alias copy="xclip -selection c"
    alias bat="batcat"
    if [ "$arch" = "x86_64" ]; then
        export PATH=/opt/nvim:$PATH
    fi
    export PATH=$HOME/.local/bin:$PATH
elif [ "$os" = "Darwin" ]; then
    PROGRAM_CHECKS="Your OS is macOS$PROGRAM_CHECKS"
    alias copy="pbcopy"
else
    PROGRAM_CHECKS="The operating system is not recognized$PROGRAM_CHECKS"
fi

# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! #
# !!!!!!!! System Specific End !!!!!!!!! #
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! #



# === EnocFlores (git base repo) ======= #
alias cdEF="cd ~/Development/EnocFlores"
alias cdTEST="cd ~/Development/Test"
alias cd\.="cd ~/Development/EnocFlores/dotfiles"

# === Git (shortened git commands) ===== #
alias gs="git status"
alias gb="git branch"
alias ga="git add ."
alias gc='f() { git commit -m $1 };f'
alias gpull='f() { git pull origin $1 || git pull portable $1 || git pull backup $1 }; f'
alias gpush='f() { git push origin $1 || git push portable $1 || git push backup $1 }; f'
# === SOMETHING USEFUL TO WORK ON ====== #
# alias gdelete="git branch -d `git branch --list 'FRONT-*'`"
alias glist='f() { git branch --list $1 };f'
alias gittree="git log --all --decorate --oneline --graph"

# === NPM (shortened npm commands) ===== #
alias nrd="npm run dev"

if [ "$os" = "Linux" ]; then
# ====================================== #
# === Example of directory dependent === #
# === alias the command:             === #
# === > /dev/null 2&>1               === #
# === DOES NOT WORK WELL ON OSX      === #
# ====================================== #
    function test_the_alias_1 {
        case $PWD/ in
            ~/Development/*) alias hello='echo "Did you mean Hello World?!"';;
            *) if whence -w hello | grep "alias" > /dev/null 2>&1; then unalias hello; fi;;
        esac
	}
	chpwd_functions+=(test_the_alias_1)
elif [ "$os" = "Darwin" ]; then
# ====================================== #
# === Suppressing grep output        === #
# === through built-in flags:        === #
# === grep -q                        === #
# ====================================== #
    function test_the_alias_2 {
        case $PWD/ in
            ~/Development/*) alias hello='echo "Did you mean Hello World?!"';;
            *) if whence -w hello | grep -Fq "alias"; then unalias hello; fi;;
        esac
    }
    chpwd_functions+=(test_the_alias_2)
else
    echo "The operating system is not recognized."
fi 

# ====================================== #
# === These functions go through all === #
# === 256 background and foreground  === #
# === colors to help in checking if  === #
# === your terminal supports such    === #
# === colors or to just see how the  === #
# === theme of your terminal changes === #
# === these colors                   === #
# ====================================== #
function showBgColors {
    for i in {0..255}; do 
        printf '\e[48;5;%dm%3d ' $i $i; 
        (((i+3) % 18)) || printf '\e[0m\n'; 
    done;
}

function showFgColors {
    for i in {0..255}; do
        printf '\e[38;5;%dm%3d ' $i $i;
        (((i+3) % 18)) || printf '\e[0m\n';
    done;
}

alias colorsBG='showBgColors'
alias colorsFG='showFgColors'

show_color() {
    perl -e 'foreach $a(@ARGV){print "\e[48:2::".join(":",unpack("C*",pack("H*",$a)))."m \e[49m "};print "\n"' "$@"
}
# ====================================== #
# ============ ALIASES END ============= #
# ====================================== #



# ====================================== #
# === Show sys info before           === #
# === initialization, but only if    === #
# === tmux is not running. I don't   === #
# === need to see my system info all === #
# === over my panes and shifting my  === #
# === previous work                  === #
# === Also make neofetch output logo === #
# === and info vertically for        === #
# === narrower screens or windows    === #
# ====================================== #
if ! ( pgrep "tmux" > /dev/null || pgrep "zellij" > /dev/null ); then
    if (( $(tput cols) > 80 )); then
        neofetch
    else
        neofetch -L
        neofetch --off
    fi
    echo "$PROGRAM_CHECKS"
fi
