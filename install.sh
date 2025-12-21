#!/bin/bash
# EnocFlores <https://github.com/EnocFlores>
# Last Change: 2025.06.05

# This script will install/check necessary programs to setup and use these dotfiles

{
# Flag, set to 0 when testing so you don't fetch from origin
testing=1

# If you fork the repo, then these variables make it easy to change this script for your own Github, make sure to replace this with your actual Github username
username="EnocFlores"
email="${username}@users.noreply.github.com"

# Note the architecture, OS, device, and current path of the user
arch=$(uname -m)
os=$(uname -s)
device=$(uname -o)
current_path=$(pwd)

# The programs_list contains all software packages that will be offered for installation
programs_list='curl git jq file tput zsh chafa fastfetch vim btop tmux neovim lf cava alacritty zellij wezterm'

# ! TESTING ! A method to use dirname and basename to install programs that have a different package name than their command name, so far it is just one so not investing the time to get this working yet, just an idea, but this might also later be used to specify how the application can be installed
# This list maps command names to package names for programs where they differ
special_snowflake_list='curl/curl git/git jq/jq file/file ncurses-utils/tput zsh/zsh chafa/chafa fastfetch/fastfetch vim/vim btop/btop tmux/tmux neovim/nvim lf/lf alacritty/alacritty zellij/zellij wezterm/wezterm'

# List of dotfiles to be managed by this script
dotfiles_list='.gitconfig .gitignore_global .zshrc .vimrc .tmux.conf .config/alacritty/alacritty.toml .config/btop/btop.conf .config/btop/themes/perox-enurple.theme .config/cava/config .config/fastfetch/config.jsonc .config/kmonad.kdb .config/nvim/init.lua .config/lf/lfrc .config/lf/previewer.sh .config/wezterm/wezterm.lua .config/yazi/theme.toml .config/zellij/config.kdl'

# Nerd font to be installed
nerd_font='RobotoMono'
nerd_font_package='roboto-mono'

# Default installation type (desktop includes GUI apps, server is minimal)
setup="desktop"

# Give the user a warning that the script is about to run in current directory
start_install_script() {
    echo -e "\033[43m\033[30mNOTE: Your are about to run this script in $PWD and the build files will also be downloaded here \033[0m"
    echo -e "\033[43m\033[30m      any build files will also be downloaded here \033[0m"
    echo -e "\033[43m\033[30mRecommended location: ~/Downloads/Builds \033[0m"
    echo -e "\033[7m\033[1m - Do you wish to continue? [y/N] \033[0m"
    read response
    if [[ $response == "y" || $response == "Y" ]]; then
        return
    fi
    echo "Aborting script."
    exit 1
}

check_network() {
    if ! curl -s --head --request GET https://github.com > /dev/null; then
        echo -e "\033[41m\033[1m\033[37mError: No internet connection. Please check your network and try again. \033[0m"
        exit 1
    fi
}

# Function to update the username in the script
update_username() {
    local new_username="$1"
    local script_path="$0"
    
    # Create backup of original script
    cp "$script_path" "${script_path}.backup"
    
    # Replace username in the script
    sed -i".temp" "s/username=\"[^\"]*\"/username=\"$new_username\"/" "$script_path"
    
    if [ $? -eq 0 ]; then
        echo "Username updated to $new_username"
        rm "${script_path}.temp"
    else
        echo -e "\033[41m\033[1m\033[37mError: Failed to update username. Restoring backup... \033[0m"
        mv "${script_path}.backup" "$script_path"
        exit 1
    fi
}

# Platform detection
detect_platform() {
    if [[ $os == "Darwin" ]]; then
        echo "macos"
    elif [[ "$device" = "Android" ]]; then
        echo "android"
    else
        echo "linux"
    fi
}

# Function to get programs list based on platform and setup
get_programs_list() {
    local platform="$1"
    local setup_type="$2"
    
    # Common programs for all platforms
    local common="curl git jq zsh vim tmux fastfetch"
    
    # Platform-specific programs
    case $platform in
        "macos")
            local platform_specific="neovim alacritty wezterm chafa btop lf cava zellij"
            ;;
        "linux")
            local platform_specific="neovim alacritty wezterm chafa btop lf cava zellij"
            ;;
        "android")
            local platform_specific="neovim chafa lf cava zellij"
            ;;
        *)
            local platform_specific="neovim"
            ;;
    esac
    
    # Filter for server setup (remove GUI applications)
    if [[ $setup_type == "server" ]]; then
        platform_specific=$(echo $platform_specific | sed 's/ alacritty//g' | sed 's/ wezterm//g' | sed 's/ cava//g')
    fi
    
    echo "$common $platform_specific"
}

# Function to get dotfiles list based on setup type
get_dotfiles_list() {
    local setup_type="$1"
    
    local common_dotfiles=".gitconfig .gitignore_global .zshrc .vimrc .config/btop/btop.conf .config/btop/themes/perox-enurple.theme .tmux.conf .config/nvim/init.lua .config/lf/lfrc .config/lf/previewer.sh"
    
    if [[ $setup_type == "desktop" ]]; then
        local desktop_dotfiles=".config/cava/config .config/alacritty/alacritty.toml .config/wezterm/wezterm.lua .config/yazi/theme.toml .config/zellij/config.kdl .config/kmonad.kdb"
        echo "$common_dotfiles $desktop_dotfiles"
    else
        echo "$common_dotfiles"
    fi
}

# Function to check what command to use for a program
get_program_command() {
    local program="$1"
    case $program in
        "neovim") echo "nvim" ;;
        *) echo "$program" ;;
    esac
}

# Function to check if program needs custom installer
needs_custom_installer() {
    local program="$1"
    local platform="$2"
    
    case $program in
        "neovim"|"alacritty"|"lf"|"zellij"|"wezterm"|"chafa")
            if [[ $platform != "macos" && $PM != "pkg" ]]; then
                return 0  # true - needs custom installer
            fi
            ;;
    esac
    return 1  # false - use package manager
}

# Function to choose what sort of setup to run for installer
# Note: For headless server no terminal emulator should be installed (alacritty and wezterm), and installing the font is not necessary
setup_type() {
    if [ -f .env ]; then
        source .env
        setup=$SETUP_SCRIPT_ENV
        echo -e "\n\033[7m\033[1m##### Found $setup env in your setup! #####\033[0m"
    else
        echo -e "\n\033[7m\033[1m##### Please select the installation type: #####\033[0m"
        options=("Desktop" "Server")
        select opt in "${options[@]}"; do
            case $opt in
                "Desktop")
                    setup="desktop"
                    break
                    ;;
                "Server")
                    setup="server"
                    break
                    ;;
                *) 
                    echo -e "\033[41m\033[1m\033[37mInvalid option. Please try again.\033[0m"
                    ;;
            esac
        done
    fi

    # Set platform and update program/dotfile lists
    platform=$(detect_platform)
    programs_list=$(get_programs_list "$platform" "$setup")
    dotfiles_list=$(get_dotfiles_list "$setup")

    if [[ $setup == "desktop" ]]; then
        echo -e "\n\033[7m\033[1m##### Running $setup version of the script! #####\033[0m"
    elif [[ $setup == "server" ]]; then
        echo -e "\n\033[7m\033[1m##### Running $setup version of the script! #####\033[0m"
    else
        echo -e "\033[41m\033[1m\033[37mError: Invalid option. Please run the script again and choose either 'desktop' or 'server'. Exiting... \033[0m"
        exit 1
    fi
}

# Function to create a directory
create_directory() {
    dir=$1
    if [ ! -d "$dir" ]; then
        mkdir -p "$dir"
        if [ ! -d "$dir" ]; then
            echo -e "\033[41m\033[1m\033[37mError: Failed to create directory. Exiting... \033[0m"
            exit 1
        fi
    fi
}

# Function to change directory
change_directory() {
    dir=$1
    if [ -d "$dir" ]; then
        cd "$dir"
    elif [ -d "$HOME/$dir" ]; then
        cd "$HOME/$dir"
    else
        echo -e "\033[41m\033[1m\033[37mError: Directory does not exist. Exiting... \033[0m"
        exit 1
    fi
}

# Function to clone or update the repository
clone_or_update_repo() {
    if [ ! -d "dotfiles" ]; then
        git clone https://github.com/$username/dotfiles.git
        if [ $? -ne 0 ]; then
            echo -e "\033[41m\033[1m\033[37mError: Failed to clone repository, check internet connection, make sure you have git installed, that the repo exists or that you have the right permissions set then try again. Exiting... \033[0m"
            exit 1
        fi
        cd dotfiles
        echo "SETUP_SCRIPT_ENV=$setup" > .env
    else
        cd dotfiles
        git pull
        if [ $? -ne 0 ] && [ $testing -ne 0 ]; then
            echo -e "\033[41m\033[1m\033[37mError: Failed to update repository, check internet connection, make sure you have git installed, that the repo exists or that you have the right permissions set then try again. Exiting... \033[0m"
            exit 1
        fi
        echo "SETUP_SCRIPT_ENV=$setup" > .env
    fi
}

# Function to change .gitconfig file after cloning or updating the repo
change_gitconfig() {
    if [ -f .gitconfig.backup ]; then
        echo -e "\033[43m\033[30mNOTE: You probably already ran the install script and changed the .gitconfig file! \033[0m"
        return
    fi
    local email="$(curl --silent "https://api.github.com/users/$username" | jq -r .id)+$email"
    sed -i".backup" -e "s/GIT_NAME/$username/g" .gitconfig
    if [ $? -eq 0 ];then
        echo " -  successfully changed .gitconfig name to $username"
    fi
    sed -i".trash" -e "s/GIT_EMAIL/$email/g" .gitconfig
    if [ $? -eq 0 ];then
        echo " -  successfully changed .gitconfig name to $email"
    fi
}

# Function to create Development repo or move into desired repo branch, clone or update the repository
setup_development_repo() {
    if [ -d "$HOME/Development/$username" ]; then
        echo -e "\n\033[7m\033[1m### You already have ~/Development/$username dir, going \$HOME(~/) \033[0m"
        cd "$HOME"
    else
        echo -e "\033[7m\033[1m### Would you like to create a new Development directory ~/Development/$username? [y/n] \033[0m"
        read yn
        case $yn in
            [Yy]* ) 
                if [ ! -d "$HOME/Development/$username" ]; then
                    create_directory "$HOME/Development/$username"
                fi
                change_directory $HOME/Development/$username;;
            [Nn]* ) 
                read -p "Please enter the full path of the existing directory where you'd like to clone the dotfiles: " dir
                change_directory "$dir";;
            * ) echo -e "\033[41m\033[1m\033[37mError: Please answer yes or no, retry the script. Exiting... \033[0m"
                exit 1;;
        esac
    fi

    clone_or_update_repo
    change_gitconfig
}

# Function to check if the script is run from the dotfiles repo
check_directory() {
    local current_dir=$(basename "$(pwd)")
    if [ "$current_dir" != "dotfiles" ]; then
        echo -e "\033[41m\033[1m\033[37mError: Run this from the dotfiles repo \033[0m"
        exit 1
    fi
}

# Function to get dotfiles - currently not used in the script (for update script)
# This function can dynamically discover dotfiles in the .config directory
# instead of using the hardcoded list
get_dotfiles() {
    # Start with the predefined list
    local result=".gitconfig .gitignore_global .zshrc .vimrc"
    
    # Add files from .config using find
    while IFS= read -r -d '' file; do
        result="$result $file"
    done < <(find .config -type f -print0)
    
    echo $result
}

# Function to compare files
compare_files() {
    cmp -s "$HOME/$1" "$1"
    cmpResult=$?
    echo $cmpResult
}

# Function to edit differences
edit_differences() {
    local file=$1
    read -p " -  Do you want to edit the differences in vimdiff? [y/N] " edit_choice
    if [[ $edit_choice == "y" || $edit_choice == "Y" ]]; then
        echo " -  Your local file is on the left, the remote file is on the right"
        read -p " -   -  Press enter to continue"
        vimdiff "$HOME/$file" "$file"
    fi
}

# Function to view differences
view_differences() {
    local file=$1
    read -p " -  Do you want to view the differences? [Y/n] " choice
    if [[ $choice != "n" && $choice != "N" ]]; then
        diff --color "$HOME/$file" "$file"
        edit_differences "$file"
    fi
}

# Function to backup files
backup_files() {
    local file=$1
    local cmpResult=$2
    if [ $cmpResult -ne 2 ];then
        read -p " -  Do you want to make a backup of your local $file? [Y/n] " backup_choice
        if [[ $backup_choice != "n" && $backup_choice != "N" ]]; then
            cp "$HOME/$file" "$HOME/$file.backup"
            echo " -  Backup of local ~/$file has been created at $HOME/$file.backup"
        fi
    fi
}

# Function to copy files
copy_files() {
    local file=$1
    local goal=$2
    if [ ! -d "$HOME/$(dirname $file)" ]; then
        mkdir -p "$HOME/$(dirname $file)"
        if [ $? -ne 0 ]; then
            echo -e "\033[41mError: Failed to make directory for $file! \033[0m"
        else
            echo "Made directory: $HOME/$(dirname $file)"
        fi
    fi
    cp "$file" "$HOME/$file"
    if [ $? -ne 0 ]; then
        echo -e "\033[41m\033[1m\033[37mError: Failed to copy file locally! \033[0m"
    fi
    echo " -  Local ~/$file has been ${goal}d with the remote one."
}

# Function to replace files
replace_files() {
    local file=$1
    local cmpResult=$2
    local goal=$3
    read -p " -  Do you want to $goal your local ~/$file $([ "$goal" = "replace" ] && echo "with" || echo "from") the remote one? [y/N] " replace_choice
    if [[ $replace_choice == "y" || $replace_choice == "Y" ]]; then
        backup_files "$file" "$cmpResult"
        copy_files "$file" "$goal"
    fi
}

# Function to handle file differences
handle_differences() {
    local file=$1
    local cmpResult=$2
    if [ $cmpResult -eq 0 ]; then
        echo -e "\033[7m\033[1m### $file files are identical \033[0m"
    elif [ $cmpResult -eq 1 ];then
        echo -e "\033[7m\033[1m### $file files are different \033[0m"
        view_differences "$file"
        replace_files "$file" "$cmpResult" "replace"
    else
        echo -e "\033[7m\033[1m### The local file ~/$file does not exist! \033[0m"
        replace_files "$file" "$cmpResult" "create"
    fi
}

# Function to setup dotfiles repo and compare dotfiles and ask user if they want to replace or create them
replace_dotfiles() {
    setup_development_repo

    for file in $dotfiles_list
    do
        cmpResult=$(compare_files "$file")
        handle_differences "$file" "$cmpResult"
    done
}

# Function to install Homebrew on Mac if not already installed
# This is necessary for Mac users since Homebrew is the primary package manager
brew_on_mac() {
    if command -v brew &> /dev/null; then
        PM="brew"
    else
        echo -e "\033[7m\033[1m### Your Mac doesn't have brew, would you like to install it? [y/N] \033[0m"
        read yn
        if [[ $yn == "y" || $yn == "Y" ]]; then
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            echo >> $HOME/.zprofile
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile
            eval "$(/opt/homebrew/bin/brew shellenv)"
            PM="brew"
        else
            echo -e "\033[43m\033[30mNote: Not using a package manager with this script might cause problems, skipping to dotfile replacement... \033[0m"
            replace_dotfiles
            exit 0
        fi
    fi
}

# Function to check for what package manager the user is using
assign_package_manager() {
    if [[ $os == "Darwin" ]]; then
        brew_on_mac
    elif [[ "$device" = "Android" ]]; then
        PM="pkg"
    elif command -v apt &> /dev/null; then
        PM="apt"
    else
        echo -e "\033[41m\033[1m\033[37mError: No supported package manager found. Exiting... \033[0m"
        exit 1
    fi
    echo -e "\033[7m\033[1m#### Your package manager is set to $PM #### \033[0m"
}

# Program installation functions
# Each of these functions handles the installation of a specific program
# They take into account different package managers and system architectures
# NOTE: The installers for the programs below are because for some of these programs we need the latest version of this is the only way to install them, it can vary from using your package manager, using an appimage, or compiling the program from source

# Build alacritty from source when not available through package manager
alacritty_installer() {
    case $PM in
        "brew") $PM install alacritty;;
        "apt")
            sudo apt install cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3 gzip scdoc
            git clone https://github.com/alacritty/alacritty.git
            cd alacritty
            command -v cargo &> /dev/null
            if [ $? -ne 0 ]; then
                curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
                . $HOME/.cargo/env
            fi
            rustup override set stable
            rustup update stable
            cargo build --release
            sudo cp target/release/alacritty /usr/local/bin # or anywhere else in $PATH
            sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
            sudo desktop-file-install extra/linux/Alacritty.desktop
            sudo update-desktop-database
            sudo mkdir -p /usr/local/share/man/man1
            sudo mkdir -p /usr/local/share/man/man5
            scdoc < extra/man/alacritty.1.scd | gzip -c | sudo tee /usr/local/share/man/man1/alacritty.1.gz > /dev/null
            scdoc < extra/man/alacritty-msg.1.scd | gzip -c | sudo tee /usr/local/share/man/man1/alacritty-msg.1.gz > /dev/null
            scdoc < extra/man/alacritty.5.scd | gzip -c | sudo tee /usr/local/share/man/man5/alacritty.5.gz > /dev/null
            scdoc < extra/man/alacritty-bindings.5.scd | gzip -c | sudo tee /usr/local/share/man/man5/alacritty-bindings.5.gz > /dev/null
            mkdir -p ${ZDOTDIR:-~}/.zsh_functions
            echo 'fpath+=${ZDOTDIR:-~}/.zsh_functions' >> ${ZDOTDIR:-~}/.zshrc
            cp extra/completions/_alacritty ${ZDOTDIR:-~}/.zsh_functions/_alacritty
            cd $current_path
            ;;
        *) echo -e "\033[43m\033[30mNOTE: Package manager not yet supported \033[0m";;
    esac
}

# Install neovim using appropriate method for the current architecture
# For x86_64: Uses AppImage
# For other architectures: Builds from source
neovim_installer() {
    case $PM in
        "brew") $PM install neovim;;
        "pkg") $PM install neovim;;
        "apt")
            if [[ $arch = "x86_64" ]]; then
                curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-$arch.appimage
                chmod u+x nvim.appimage
                mkdir -p $HOME/.local/bin/
                mv nvim.appimage $HOME/.local/bin/nvim
            else
                sudo apt-get install ninja-build gettext cmake unzip curl
                git clone https://github.com/neovim/neovim
                cd neovim && make CMAKE_BUILD_TYPE=Release
                sudo make install
                mkdir -p $HOME/.local/bin
                mv build/bin/nvim $HOME/.local/bin/
                cd $current_path
            fi
            ;;
        *) echo -e "\033[43m\033[30mNOTE: Package manager not yet supported \033[0m";;
    esac
}

# Install lf file manager by downloading the appropriate binary for the system architecture
lf_installer() {
    local lf_os="null"
    if [[ $arch = "x86_64" ]];then
        lf_os="amd64"
    elif [[ $arch = "aarch64" ]];then
        lf_os="arm64"
    else
        echo -e "\033[43m\033[30mNOTE: Architecture not supported by this script at this time, skipping... \033[0m"
        return
    fi
    curl -fLo "lf-linux-$lf_os.tar.gz" "https://github.com/gokcehan/lf/releases/latest/download/lf-linux-$lf_os.tar.gz"
    tar -xzf lf-linux-$lf_os.tar.gz
    sudo mv lf /usr/local/bin
}

# Install zellij binary for linux
zellij_installer() {
    curl -fLo "zellij-$arch-unknown-linux-musl.tar.gz" "https://github.com/zellij-org/zellij/releases/latest/download/zellij-$arch-unknown-linux-musl.tar.gz"
    tar -xzf zellij-$arch-unknown-linux-musl.tar.gz
    chmod +x zellij
    sudo mv zellij /usr/local/bin
}

# Build wezterm from source
wezterm_installer() {
    command -v cargo &> /dev/null
    if [ $? -ne 0 ]; then
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
        . $HOME/.cargo/env
    fi
    local github_version=$(curl --silent "https://api.github.com/repos/wezterm/wezterm/releases/latest" | jq -r .tag_name)
    curl -LO "https://github.com/wezterm/wezterm/releases/download/$github_version/wezterm-$github_version-src.tar.gz"
    tar -xzf wezterm-$github_version-src.tar.gz
    cd wezterm-$github_version
    ./get-deps
    cargo build --release
    cargo run --release --bin wezterm -- start
    sudo ln -s $PWD/target/release/wezterm /usr/local/bin/wezterm
    sudo cp assets/icon/wezterm-icon.svg /usr/share/pixmaps/WezTerm.svg
    sed -i" " -e "s/org.wezfurlong.wezterm/WezTerm/g" assets/wezterm.desktop
    sudo desktop-file-install assets/wezterm.desktop
    sudo update-desktop-database
    cd $current_path
}

# WIP
chafa_installer(){
    sudo $PM install build-essential make autoconf automake libtool pkg-config libglib2.0-dev libfreetype6-dev libjpeg-dev librsvg2-dev libtiff5-dev libwebp-dev gtk-doc-tools
    github_version=$(curl --silent "https://api.github.com/repos/hpjansson/chafa/releases/latest" | jq -r .tag_name)
    current_version=$(chafa --version | head -n 1 | awk '{print $NF}')
    curl -fLo "chafa-1.14.0.tar.gz" "https://github.com/hpjansson/chafa/archive/refs/tags/1.14.0.tar.gz"
    tar -xzf chafa-1.14.0.tar.gz
    cd chafa-1.14.0
    ./autogen.sh
    ./autogen.sh
    make
    sudo rm /usr/local/bin/chafa
    sudo ln -s $PWD/tools/chafa/chafa /usr/local/bin/chafa
    cd $current_path
}

# Main program installation function
# This function iterates through the programs list and offers to install each one
# It uses specialized installers for certain programs and falls back to package manager for others
programs_installer() {
    for program in $programs_list
    do
        local command_name=$(get_program_command "$program")
        local platform=$(detect_platform)

        if command -v $command_name &> /dev/null; then
            echo -e "\033[7m\033[1m### You already have $program installed \033[0m"
        elif [[ $device == "Android" && ( $program == "alacritty" || $program == "wezterm"  || $program == "btop" ) ]]; then
            echo "Skip!" &> /dev/null
        else
            echo -e "\033[7m\033[1m### Would you like to install $program? [y/N] \033[0m"
            read yn
            case $yn in
                [Yy]* ) 
                    if needs_custom_installer "$program" "$platform"; then
                        case $program in
                            "neovim") neovim_installer ;;
                            "alacritty") alacritty_installer ;;
                            "lf") lf_installer ;;
                            "zellij") zellij_installer ;;
                            "wezterm") wezterm_installer ;;
                            "chafa") chafa_installer ;;
                        esac
                    else
                        if [[ $PM == "brew" || $PM == "pkg" ]]; then
                            $PM install $program
                        else
                            sudo $PM install $program
                        fi
                        
                        if [ $? -ne 0 ]; then
                            echo -e "\033[41m\033[1m\033[37mError: Failed to install $program with $PM \033[0m"
                            exit 1
                        fi
                    fi
                    ;;
                [Nn]* ) echo "Skipping $program.";;
                * ) echo "Please answer yes or no.";;
            esac
        fi
    done
}

# Function to change the user's default shell to zsh
# This is important since many of the dotfiles assume zsh is being used
change_shell() {
    if [[ "$(basename $SHELL)" != "zsh" ]]; then
        echo -e "\033[7m\033[1m### Do you want to change your shell to zsh? (most things in this script won't work if you don't) [Y/n] \033[0m"
        read yn
        case $yn in
            [Nn]* )
                echo "Don't forget to add all there right configs to your preferred shell!";;
            * )
                chsh -s /bin/zsh;;
        esac
    fi
}

# Install Nerd Font
nerd_font_installer() {
    fc-list | grep "$nerd_font Nerd Font Mono" > /dev/null
    if [ $? -eq 0 ]; then
        echo -e "\033[7m\033[1m### You already have $nerd_font Nerd Font installed \033[0m"
    elif [[ $PM == 'brew' ]]; then
        echo -e "\033[7m\033[1m### Installing $nerd_font Nerd Font \033[0m"
        brew install --cask font-$nerd_font_package-nerd-font
    else
        echo -e "\033[7m\033[1m### Downloading and installing $nerd_font Nerd Font \033[0m"
        mkdir nerd-font && cd nerd-font
        curl -fLo "$nerd_font.tar.xz" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/$nerd_font.tar.xz"
        tar -xf $nerd_font.tar.xz
        if [ ! -d $HOME/.fonts ];then
            mkdir -p $HOME/.fonts
        fi
        mv *.ttf $HOME/.fonts/
        fc-cache -f -v
        cd $current_path
    fi
}

# Main installation function that orchestrates the entire setup process
# 1. Starts with confirmation prompt
# 2. Offers username change
# 3. Determines setup type (desktop/server)
# 4. Assigns package manager
# 5. Installs programs, changes shell, installs fonts, and sets up dotfiles
install_script() {
    check_network
    start_install_script

    echo -e "\033[7m\033[1m### Would you like to change the default username ($username) for this script? [y/N] \033[0m"
    read yn
    case $yn in
        [Yy]* )
            read -p "Enter your GitHub username: " new_username
            update_username "$new_username"
            echo -e "\033[43mNOTE: Username updated. Please rerun the script for changes to take effect: ./install.sh \033[0m"
            exit 0
            ;;
        [Nn]* | * )
            echo "Continuing with username: $username"
            ;;
    esac

    check_network
    setup_type
    assign_package_manager

    check_network
    if [[ $setup == "desktop" ]]; then
        programs_installer
        change_shell
        nerd_font_installer
        replace_dotfiles
    elif [[ $setup == "server" ]]; then
        programs_installer
        change_shell
        replace_dotfiles
    fi

    exit 0
}

current_dir=$(basename "$current_path")
if [ "$current_dir" != "dotfiles" ]; then
    install_script
fi

}
