# EnocFlores <https://github.com/EnocFlores>
# Last Change: 2024.03.06



# === Important system variables ======= #
arch=$(uname -m)
os=$(uname -s)
device=$(uname -o)

PROGRAM_CHECKS=""

fpath+=${ZDOTDIR:-~}/.zsh_functions



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

# ====================================== #
# === Set some env variables for     === #
# === editors                        === #
# ====================================== #
export EDITOR='vim'
export VISUAL='vim'

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
    export PS1='%B%K{016}%F{2} %n@%m %f%k%K{017} %F{cyan} %1~%f %k%K{053}%F{201}$(parse_git_branch)%f %F{2}%#%f %k%F{053} %f%b'
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
    echo "The tpm plugin is not installed. Do you want to install it now? (y/n)"
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
    PROGRAM_CHECKS="$PROGRAM_CHECKS\nnvm is installed"
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
else
    PROGRAM_CHECKS="$PROGRAM_CHECKS\nnvm is not installed"
fi

# ====================================== #
# ============== ALIASES =============== #
# ====================================== #

# === Edit zsh File ==================== #
alias edita="vim ~/.zshrc"

# === Basic aliases ==================== #
alias ls="ls --color=auto"
alias cls="clear"
alias python="python3.11"
alias diff="diff --color"
alias editav="vim ~/.vimrc"
alias editanv="vim ~/.config/nvim/init.lua"
alias editatx="vim ~/.tmux.conf"
alias editat="vim ~/.config/alacritty/alacritty.toml"
alias editaw="vim ~/.config/wezterm/wezterm.lua"
alias editaz="vim ~/.config/zellij/config.kdl"
alias vims="nvim -S Session.vim"
alias icat="wezterm imgcat"



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
    export PATH=$HOME/.cargo/bin:$PATH
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
