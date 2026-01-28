# EnocFlores <https://github.com/EnocFlores>
# Last Change: 2025.12.20



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
HISTSIZE=5000

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
export LS_COLORS="rs=0:di=44;36;01:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.avif=01;35:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.webp=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:*~=00;90:*#=00;90:*.bak=00;90:*.bkup=00;90:*.backup=00;90:*.old=00;90:*.orig=00;90:*.part=00;90:*.rej=00;90:*.swp=00;90:*.tmp=00;90:*.dpkg-dist=00;90:*.dpkg-old=00;90:*.ucf-dist=00;90:*.ucf-new=00;90:*.ucf-old=00;90:*.rpmnew=00;90:*.rpmorig=00;90:*.rpmsave=00;90:"
export LSCOLORS="Gefxcxdxbxegedabagacad"



# ====================================== #
# ===          PROMPT                === #
# ====================================== #
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! #
# !!! DEP. on having nerd font       !!! #
# !!! installed for desired affect   !!! #
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! #

# ====================================== #
# === allow the use of functions and === #
# === variables in prompt             == #
# ====================================== #
# ====================================== #
setopt prompt_subst

# ====================================== #
# === Show git branch names in shell === #
# === prompt                         === #
# ====================================== #
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/  (\1)/'
}

if [ "$TERM" = "linux" ];then
    export PS1='%K{0}%B%F{2} %n@%m %f%b%k%K{4} %B%F{6} %1~%f%b %k%K{5}%B%F{5}$(parse_git_branch)%f%b %B%F{2}%# %k %f%b'
else
    # export PS1='%B%K{016}%F{2} %n@%m %f%k%K{017} %F{cyan} %1~%f %k%K{053}%F{201}$(parse_git_branch)%f %F{2}%#%f %k%F{053} %f%b'
    # export PS1='%B%K{0}%F{2} %n@%m %f%k%K{4} %F{cyan} %1~%f %k%K{5}%F{201}$(parse_git_branch)%f %F{2}%#%f %k%b%F{5} %f'

    # System icon
    local system_icon="@"
    case $device in
        Darwin) system_icon="()";;
        GNU/Linux) system_icon="()";;
        Android) system_icon="()";;
        *) system_icon="@";;
    esac

    # User and machine
    local usermachine='%B%K{0}%F{2}  %n%f${system_icon}%F{2}%m%f %k%b%F{0}'

    # Directory
    local directory='%B%K{4}%F{14}  %1~%f %k%b%F{4}'

    # Git branch
    local gitbranch='%B%K{5}%F{201}$(parse_git_branch)%f %F{2}%#%f %k%b%F{5}'

    # Point divider
    local point_divider='%f'
    local triangle='%f'
    local arrow_right='%f'
    # local arrow_right='󰅂%f'
    # local arrow_right='❯%f'

    # Combine them and export PS1
    export PS1="${usermachine}${directory}${gitbranch}${point_divider} "
    export PS2="- "

    local exit_color="%F{10}"

    function prompt_builder() {
        local usermachine_chars="   $(whoami)   $(hostname) "
        local usermachine_length=${#usermachine_chars}
        local directory_chars="   $(echo $(if [[ $(basename $PWD) == $(whoami) ]]; then echo ' '; else echo $(basename $PWD); fi)) "
        local directory_length=${#directory_chars}
        local gitbranch_chars="$(parse_git_branch)   "
        local gitbranch_length=${#gitbranch_chars}

        local width=$(tput cols)

        # echo $usermachine_length + $directory_length + $gitbranch_length
        # echo $((usermachine_length + directory_length + 2))
        # echo $((width))
        # echo $(( usermachine_length + directory_length + 3 >= width ))

        if (( usermachine_length + directory_length + 3 >= width )); then
            PROMPT="${usermachine}${triangle}"$'\n'"${directory}${triangle}"$'\n'"${gitbranch}${triangle}"$'\n'"${arrow_right} "
        elif (( usermachine_length + directory_length + gitbranch_length + 4 >= width )); then
            PROMPT="${usermachine}${directory}${triangle}"$'\n'"${gitbranch}${triangle}"$'\n'"${arrow_right} "
        else
            PROMPT="${usermachine}${directory}${gitbranch}${point_divider} "
        fi
        # echo "builder func success $usermachine"
    }

    function status_indicator() {
        if [[ $? -eq 0 ]]; then
            # If the last command was successful, set the color to green
            exit_color="%F{10}"
        else
            # If the last command failed, set the color to red
            exit_color="%F{9}"
        fi
        # Set the prompt, using the color for %m
        indicator_icon="${exit_color}${system_icon}%f"

        # User and machine
        usermachine='%B%K{0}%F{2}  %n%f${indicator_icon}%F{2}%m%f %k%b%F{0}'
        prompt_builder
    }
    precmd_functions+=(status_indicator)

    # PROMPT="${usermachine} ${directory}"$'\n'"${gitbranch}"
    function TRAPWINCH() {
        prompt_builder
    }

    # To get length of varible use: ${#VAR}
    # The precmd() function is executed before each prompt
    # The TRAPWINCH() function is executed when the terminal window is resized
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

# === Search history better ============ #
bindkey '^R' history-incremental-search-backward

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

if [ "$device" != "Android" ]; then
# === Point NVM to config directory ==== #
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi

# ====================================== #
# === NVM installation TO BE REPLACED=== #
# === with mise                      === #
# ====================================== #

if [ "$device" != "Android" ]; then
    eval "$(/Users/enfloreshernandez/.local/bin/mise activate zsh)"

    # ====================================== #
    # === mise checker and installer     === #
    # ====================================== #
    if ! command -v mise &> /dev/null; then
        # If mise is not installed then prompt user to install
        echo "mise is not installed, would you like to install it? [y/N]"
        read answer

        if [ "$answer" = "y" ]; then
            curl https://mise.run | sh
        else
            PROGRAM_CHECKS="$PROGRAM_CHECKS\nmise is not installed"
        fi
    else
        PROGRAM_CHECKS="$PROGRAM_CHECKS\nmise is installed and activated"
    fi

    # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! #
    # !!! place this after mise          !!! #
    # !!! initialization                 !!! #
    # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! #
    # ====================================== #
    # === Changes npm version depending  === #
    # === on .nvm file (if it exists in  === #
    # === current directory/repo)        === #
    # ====================================== #

    # === FOR LATER USE ONCE TESTED ======== #
    if command -v mise &> /dev/null; then
        autoload -U add-zsh-hook
        load-nvmrc() {
            # local node_version="$(nvm version)"
            # local nvmrc_path="$(nvm_find_nvmrc)"
            if [ -n ".nvmrc" ]; then
                mise install
            else
                echo "Reverting to mise default version"
            fi
        }
        add-zsh-hook chpwd load-nvmrc
        load-nvmrc
    fi

    # === OLD NVM SCRIPT FOR REFERENCE   === #
    # if command -v nvm &> /dev/null; then
    #     autoload -U add-zsh-hook
    #     load-nvmrc() {
    #         local node_version="$(nvm version)"
    #         local nvmrc_path="$(nvm_find_nvmrc)"

    #          if [ -n "$nvmrc_path" ]; then
    #              local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    #              if [ "$nvmrc_node_version" = "N/A" ]; then
    #                  nvm install
    #              elif [ "$nvmrc_node_version" != "$node_version" ]; then
    #                 nvm use
    #             fi
    #         elif [ "$node_version" != "$(nvm version default)" ]; then
    #             echo "Reverting to nvm default version"
    #             nvm use default
    #         fi
    #     }
    #     add-zsh-hook chpwd load-nvmrc
    #     load-nvmrc
    # fi
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
alias python="python3"
alias diff="diff --color"
alias nvim="mise exec node@22.19.0 -- nvim"
alias vims="nvim -S Session.vim"
alias icat="wezterm imgcat"
alias top="btop -p 3"
alias btop="btop -p 2"
alias tlock="tmux setw prefix None"
alias tunlock="tmux setw prefix C-t"
alias nowork="figlet -f doh -w 210 COMPLETED | lolcat -F 0.5"
alias shistory="cat ~/.zsh_history | fzf | copy"
# choose between yazi and lf as I transition
alias lf='echo "Choose: [l]f or [y]azi (yazi)?" && read -k1 choice && echo && case $choice in l) command lf;; y) yazi;; *) echo "Invalid choice";; esac'

mount_container() {
    container_path=$1
    # mount_point=$2
    filename=$(basename "$container_path" .${container_path##*.})
    mount_dir=~/Vaults/$filename

    # Create the directory if it doesn't exist
    if [ ! -d "$mount_dir" ]; then
        mkdir -p "$mount_dir"
    fi

    # Check if it's a CryFS container
    if [ -f "$container_path/cryfs.config" ]; then
        # cryfs "$container_path" "$mount_point"
        LC_ALL=C cryfs "$container_path" "$mount_dir"
    elif [ -f "$container_path/gocryptfs.conf" ]; then
        # gocryptfs "$container_path" "$mount_point"
        gocryptfs "$container_path" "$mount_dir"
    else
        echo "Not a encrypted container"
    fi

    if [ $? -ne 0 ]; then
        echo "Failed to mount container"
    fi
}

unmount_container() {
    container_name=$1
    container_type=$2

    # Unmount the container
    if [ "$container_type" = "cryfs" ]; then
        LC_ALL=C cryfs-unmount ~/Vaults/$container_name
    else
        if [ "$os" = "Darwin" ]; then
            umount ~/Vaults/$container_name
        else
            fusermount -u ~/Vaults/$container_name
        fi
    fi

    if [ $? -ne 0 ]; then
        echo "Failed to unmount container"
    fi
}

alias cMount=mount_container
alias cUnmount=unmount_container
alias cList="find ~/Vaults -maxdepth 1 -type d -not -empty | tail -n +2 | xargs -I {} basename {} | sort"
alias cBusy='f() { lsof +f -- ~/Vaults/"$1" };f'

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! #
# !!!!!!!! System Specific Start !!!!!!! #
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! #

if [ "$os" = "Linux" ]; then
    PROGRAM_CHECKS="Your OS is Linux$PROGRAM_CHECKS"
    alias bat="batcat"
    if [ "$XDG_SESSION_TYPE" = "x11" ]; then
        alias copy="xclip -selection c"
    fi
    if [ "$arch" = "x86_64" ]; then
        export PATH=/opt/nvim:$PATH
    fi
elif [ "$os" = "Darwin" ]; then
    PROGRAM_CHECKS="Your OS is macOS$PROGRAM_CHECKS"
    export DOCKER_HOST="unix://${HOME}/.colima/docker.sock"
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
alias gd="git diff"
alias ga="git add -p"
alias gc='f() { git commit -m $1 };f'
alias gpull='f() { git pull origin $1 || git pull portable $1 || git pull backup $1 }; f'
alias gpush='f() { git push origin $1 || git push portable $1 || git push backup $1 }; f'
alias gedit='nvim $(git diff --name-only)'

# ====================================== #
# =========== GIT WORKTREES ============ #
# ====================================== #

# The following is used by the gws (git worktree sync) alias to sync files
worktreesSyncedFiles=(".env.local" ".vim/coc-settings.json" "AGENTS.md" ".ignore" "agent-resources" "opencode.jsonc")

gw() { 
  if [[ "$1" == "bare" ]]; then
    cd $(git worktree list | head -1 | awk '{print $1}')
  else
    cd $(git worktree list | grep "/$1 " | awk '{print $1}')
  fi
}

## Completion function for gw
_gw_completion() {
  local -a worktrees
  worktrees=($(git worktree list | awk '{if(NR==1) print "bare"; else {gsub(".*/", "", $1); print $1}}'))
  _values 'worktree' ${worktrees[@]}
}

## Register the completion
compdef _gw_completion gw

alias gwl='git worktree list | sed "s|^$(pwd) |* & |"'

# f( <worktree-name> <branch-name> )
create_worktree() {
  local repo_root
  
  # Check if we're in any kind of git repository
  if ! git rev-parse --git-dir >/dev/null 2>&1; then
    echo "Error: Not in a git repository or worktree"
    return 1
  fi
  
  # Determine repo root based on repository type
  if git rev-parse --is-bare-repository >/dev/null 2>&1 && [[ "$(git rev-parse --is-bare-repository)" == "true" ]]; then
    # We are in a bare repository
    repo_root=$(git rev-parse --git-dir)
  else
    # We are in a regular repository or worktree
    repo_root=$(git rev-parse --show-toplevel)
    
    if [[ "$repo_root" == *".worktrees"* ]]; then
      # We are in a worktree, go to parent directory
      repo_root="${repo_root%/.worktrees*}"
    fi
  fi

  # Create the worktree
  if [[ "$3" == "new" ]]; then
    git worktree add -b "$2" "$repo_root/.worktrees/$1"
  else
    git fetch origin $2:$2 && git worktree add "$repo_root/.worktrees/$1" "$2"
  fi

  if [ $? -ne 0 ]; then
    echo "Failed to create worktree"
    echo "Usage: gwa <worktree-name> <branch-name> <new>(optional)"
    return 1
  fi

  cd "$repo_root/.worktrees/$1"
}
alias gwa='f() { create_worktree $1 $2 $3 };f'

alias gwd='f() { git worktree remove $1 };f'

# ====================================== #
# === This creates symbolic links to === #
# === the files/directories you want === #
# === to share across all your other === #
# === worktrees                      === #
# ====================================== #
gws() {
    for file in "${worktreesSyncedFiles[@]}"; do
        if [[ -e "../../$file" || -L "../../$file" ]]; then
            # Create parent directory if it doesn't exist
            local parent_dir=$(dirname "$file")
            if [[ "$parent_dir" != "." && ! -d "$parent_dir" ]]; then
                echo "Creating directory $parent_dir"
                mkdir -p "$parent_dir"
            fi
            
            if [[ -e "$file" || -L "$file" ]]; then
                echo "Removing existing $file"
                rm -rf "$file"
            fi
            echo "Linking $file -> ../../$file"
            ln -sfn "../../$file" "$file"
        else
            echo "Warning: ../../$file does not exist, skipping"
        fi
    done
    
    echo "Worktree sync complete!"
}

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

# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! #
# !!!!!!!!!!!! PRIVATE INFO START   !!!!!!!!!!!! #
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! #

[[ -f ~/.zshrc_private ]] && source ~/.zshrc_private

# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! #
# !!!!!!!!!!!! PRIVATE INFO END   !!!!!!!!!!!!!! #
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! #



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
        if [ "$GUI_TERM" = "WEZTERM" ]; then
            echo "$(fastfetch -l none | pr -t -o 30)"; echo -e "\033[18A"; icat --width 30 "$HOME/.config/penguinpower.gif"
        else
            fastfetch
        fi
        # penguinpower.gif obtained from Elizabeth Grimm's website "Tux (the Linux mascot)", no credit was given to this image but it is the oldest reference I could find, claimed to be public domain
        # ref: https://www3.nd.edu/~ljordan/linux/tuxgallery.html
    else
        fastfetch -s none
        fastfetch -l none
    fi
    echo "$PROGRAM_CHECKS"
fi

export PATH=$HOME/.local/bin:$PATH

export MANPAGER="vim +MANPAGER --not-a-term -"
