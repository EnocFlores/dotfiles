# Set zsh theme
# ZSH_THEME="agnoster"

# Show git branches in shell prompt
setopt prompt_subst
parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
export PS1='%n@%m %F{cyan}%1~%f%F{201}$(parse_git_branch)%f %#  '

# Enable zsh advanced tab complete
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)

# vi mode
bindkey -v
export KEYTIMEOUT=1

# Use vim keys in tap completion menu
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char

# Edit command in vim
autoload edit-command-line; zle -N edit-command-line
bindkey '^v' edit-command-line

# Fix backspace vim bug
bindkey '^?' backward-delete-char

# Show vim status
function zle-line-init zle-keymap-select {
	RPS1="${${KEYMAP/vicmd/-- NORMAL --}/(main|viins)/-- INSERT --}"
  RPS2=$RPS1
  zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

### ALIASES ###

# Edit zsh File
alias edita="vim ~/.zshrc"

# EnocFlores (github base repo)
alias cdEF="cd ~/Documents/EnocFlores"
alias cdTEST="cd ~/Documents/Test"

# Git (shortened git commands)
alias gs="git status"
alias gb="git branch"
alias ga="eslint . && git add ."
alias gc='f() { git commit -m $1 };f'
alias gpull='f() { git pull origin || git pull portable $1 || git pull backup $1 }; f'
alias gpush='f() { git push origin || git push portable $1 || git push backup $1 }; f'
# SOMETHING USEFUL TO WORK ON
# alias gdelete="git branch -d `git branch --list 'FRONT-*'`"
alias glist='f() { git branch --list $1 };f'

neofetch
