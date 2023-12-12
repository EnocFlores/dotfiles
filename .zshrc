# EnocFlores <https://github.com/EnocFlores>
# Last Change: 2023.12.12



# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! #
# !!!!!!!!!!!! MacOS Specific Start !!!!!!!!!!!! #
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! #

# === Add Homebrew command ===================== #
export PATH=/opt/homebrew/bin:$PATH

# ============================================== #
# === Use Homebrew version of openssh to fix === #
# === issue of Xcode using an outdated       === #
# === version of the openssh command         === #
# ============================================== #
export PATH=$(brew --prefix openssh)/bin:$PATH

# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! #
# !!!!!!!!!!!! MacOS Specific End !!!!!!!!!!!!!! #
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! #



# === Set zsh theme ============================ #
# ZSH_THEME="~/.config/themes/wildberries.zsh-theme"
# source "~/.config/themes/wildberries.zsh-theme"

# ============================================== #
# === Enable the use of keeping commands     === #
# === from being written into history if     === #
# === space is the first character           === #
# ============================================== #
setopt HIST_IGNORE_SPACE

# ============================================== #
# === Share history between all your zsh     === #
# === sessions, very useful if you use       === #
# === multiple terminals or tmux             === #
# ============================================== #
setopt sharehistory

# ============================================== #
# === Enable if you want to ignore duplicate === #
# === commands, useful to keep your history  === #
# === de-cluttered from the same commands    === #
# ============================================== #
# setopt histignorealldups

# ============================================== #
# === Keep 1000 lines of history within the  === #
# === scrollable shell history               === #
# ============================================== #
HISTSIZE=1000
# ============================================== #
# === Save 10000 lines of history and store  === #
# === it in the ~/.zsh_history file          === #
# ============================================== #
SAVEHIST=10000
HISTFILE=~/.zsh_history

# === Set some env variables for editors ======= #
export EDITOR='vim'
export VISUAL='vim'

# === Show git branch names in shell prompt ==== #
# !!! DEP. on having nerd font installed !!!!!!! #
setopt prompt_subst
parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/  (\1)/'
}
if [ "$TERM" = "linux" ];then
	export PS1='%K{0}%B%F{2} %n@%m %f%b%k%K{4} %B%F{6} %1~%f%b %k%K{5}%B%F{5}$(parse_git_branch)%f%b %B%F{2}%# %k %f%b'
else
	export PS1='%B%K{016}%F{2} %n@%m %f%k%K{017} %F{cyan} %1~%f %k%K{053}%F{201}$(parse_git_branch)%f %F{2}%#%f %k%F{053} %f%b'
fi

# === Enable zsh advanced tab completion ======= #
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)

# === Enable vi mode =========================== #
bindkey -v
export KEYTIMEOUT=1

# === Use vim keys in tab completion menu ====== #
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char

# === Edit command in vim ====================== #
autoload edit-command-line; zle -N edit-command-line
bindkey '^v' edit-command-line

# === Fix backspace vim bug ==================== #
bindkey '^?' backward-delete-char

# === Show vim mode on right side of prompt ==== #
function zle-line-init zle-keymap-select {
	RPS1='${${KEYMAP/vicmd/-- NORMAL --}/(main|viins)/-- INSERT --}'
  RPS2=$RPS1
  zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

# === Point NVM to config directory ============ #
export NVM_DIR=~/.nvm

# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! #
# !!!!!!!!!!!! MacOS Specific Start !!!!!!!!!!!! #
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! #

source $(brew --prefix nvm)/nvm.sh

# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! #
# !!!!!!!!!!!! MacOS Specific End !!!!!!!!!!!!!! #
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! #

# !!! place this after nvm initialization !!!!!! #
# ============================================== #
# === Changes npm version depending on .nvm  === #
# === file (if it exists in current          === #
# === directory/repo)                        === #
# ============================================== #
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

# ============================================== #
# ================== ALIASES =================== #
# ============================================== #

# === Edit zsh File ============================ #
alias edita="vim ~/.zshrc"

# === Basic aliases ============================ #
alias ls="ls --color=auto"
alias cls="clear"
alias python="python3"
alias editav="vim ~/.vimrc"
alias editatx="vim ~/.tmux.conf"



# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! #
# !!!!!!!!!!!! Linux Specific Start !!!!!!!!!!!! #
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! #

alias copy="xclip -selection c"
alias bat="batcat"

# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! #
# !!!!!!!!!!!! Linux Specific End !!!!!!!!!!!!!! #
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! #



# === EnocFlores (git base repo) =============== #
alias cdEF="cd ~/Development/EnocFlores"
alias cdTEST="cd ~/Development/Test"

# === Git (shortened git commands) ============= #
alias gs="git status"
alias gb="git branch"
alias ga="git add ."
alias gc='f() { git commit -m $1 };f'
alias gpull='f() { git pull origin $1 || git pull portable $1 || git pull backup $1 }; f'
alias gpush='f() { git push origin $1 || git push portable $1 || git push backup $1 }; f'
# === SOMETHING USEFUL TO WORK ON ============== #
# alias gdelete="git branch -d `git branch --list 'FRONT-*'`"
alias glist='f() { git branch --list $1 };f'

# === NPM (shortened npm commands) ============= #
alias nrd="npm run dev"

# ============================================== #
# === Example of directory dependent alias   === #
# === the command: > /dev/null 2&>1          === #
# === DOES NOT WORK WELL ON OSX              === #
# ============================================== #
function test_the_alias_1 {
	case $PWD/ in
		~/Development/*) alias hello='echo "Did you mean Hello World?!"';;
		*) if whence -w hello | grep "alias" > /dev/null 2&>1; then unalias hello; fi;;
	esac
}
# chpwd_functions+=(test_the_alias_1)

# ============================================== #
# === Suppressing grep output through        === #
# === built-in flags: grep -q                === #
# ============================================== #
function test_the_alias_2 {
	case $PWD/ in
		~/Development/*) alias hello2='echo "Did you mean Hello World?!"';;
		*) if whence -w hello2 | grep -Fq "alias"; then unalias hello2; fi;;
	esac
}
chpwd_functions+=(test_the_alias_2)

# ============================================== #
# ================ ALIASES END ================= #
# ============================================== #

# ============================================== #
# === Show sys info before initialization,   === #
# === but only if tmux is not running. I     === #
# === don't need to see my system info all   === #
# === over my panes and shifting my previous === #
# === work                                   === #
# ============================================== #
if ! pgrep "tmux" > /dev/null
then
	neofetch
fi
