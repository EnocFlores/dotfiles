#!/bin/bash
# EnocFlores <https://github.com/EnocFlores>
# Last Change: 2026.03.09

# This script will install/check necessary programs to setup and use these dotfiles

{
# Flag, set to 0 when testing so you don't fetch from origin
testing=0

# If you fork the repo, then these variables make it easy to change this script for your own Github, make sure to replace this with your actual Github username
username="EnocFlores"
email="${username}@users.noreply.github.com"

# Nerd font to be installed
nerd_font='RobotoMono'
nerd_font_package='roboto-mono'

# Default installation type (desktop includes GUI apps, server is minimal)
setup="desktop"

# Note the architecture, OS, device, and current path of the user
arch=$(uname -m)
os=$(uname -s)
device=$(uname -o)
current_path=$(pwd)

# Color codes for faster modification and better readability of the script
WARNING="\033[43m\033[30m"
ERROR="\033[41m\033[1m\033[37m"
INVERTED="\033[7m\033[1m"
RESET_COLOR="\033[0m"

RED="\033[31m"
YELLOW="\033[33m"
GREEN="\033[32m"

# The programs_list contains all software packages that will be offered for installation
programs_list='curl git jq file tput zsh chafa fastfetch vim btop tmux nvim yazi cava alacritty zellij wezterm'

# Core programs (essential for all environments)
programs_core='curl git jq file tput zsh vim btop tmux yazi'

# Development tools for desktop environments
programs_desktop='nvim alacritty chafa zellij'

# Full/Heavy programs that are not necessary for devs, just personal preference
programs_full='fastfetch cava wezterm'

# Mac specific programs
programs_macos='aerospace raycast'

# List of dotfiles to be managed by this script
dotfiles_list='.gitconfig .gitignore_global .zshrc .vimrc .tmux.conf .config/alacritty/alacritty.toml .config/btop/btop.conf .config/btop/themes/perox-enurple.theme .config/cava/config .config/fastfetch/config.jsonc .config/kmonad.kdb .config/nvim/init.lua .config/lf/lfrc .config/lf/previewer.sh .config/wezterm/wezterm.lua .config/yazi/theme.toml .config/zellij/config.kdl'

get_package_name() {
    local program="$1"
    local pm="$2"
    
    case "$program:$pm" in
        "file:brew") echo "file-formula" ;;

        "tput:apt") echo "ncurses-bin" ;;
        "tput:apk") echo "ncurses" ;;
        "tput:brew") echo "ncurses" ;;
        "tput:dnf") echo "ncurses" ;;
        "tput:pkg") echo "ncurses-utils" ;;

        "chafa:apt") echo "MANUAL" ;;
        "chafa:apk") echo "chafa" ;;
        "chafa:brew") echo "chafa" ;;
        "chafa:dnf") echo "chafa" ;;
        "chafa:pkg") echo "chafa" ;;

        "fastfetch:apt") echo "fastfetch" ;;
        "fastfetch:apk") echo "fastfetch" ;;
        "fastfetch:brew") echo "fastfetch" ;;
        "fastfetch:dnf") echo "fastfetch" ;;
        "fastfetch:pkg") echo "fastfetch" ;;

        "nvim:apt") echo "MANUAL" ;;
        "nvim:apk") echo "neovim" ;;
        "nvim:brew") echo "neovim" ;;
        "nvim:dnf") echo "neovim" ;;
        "nvim:pkg") echo "neovim" ;;

        "yazi:apt") echo "MANUAL" ;;
        "yazi:apk") echo "yazi" ;;
        "yazi:brew") echo "yazi" ;;
        "yazi:dnf") echo "MANUAL" ;;
        "yazi:pkg") echo "yazi" ;;

        "zellij:apt") echo "MANUAL" ;;
        "zellij:apk") echo "zellij" ;;
        "zellij:brew") echo "zellij" ;;
        "zellij:dnf") echo "zellij" ;;
        "zellij:pkg") echo "zellij" ;;

        "alacritty:apt") echo "MANUAL" ;;
        "alacritty:apk") echo "alacritty" ;;
        "alacritty:brew") echo "alacritty" ;;
        "alacritty:dnf") echo "alacritty" ;;
        "alacritty:pkg") echo "alacritty" ;;

        "wezterm:apt") echo "MANUAL" ;;
        "wezterm:apk") echo "wezterm" ;;
        "wezterm:brew") echo "wezterm" ;;
        "wezterm:dnf") echo "wezterm" ;;
        "wezterm:pkg") echo "wezterm" ;;

        "aerospace:brew") echo "--cask nikitabobko/tap/aerospace" ;;

        *) echo "$program" ;;
    esac
}

# Give the user a warning that the script is about to run in current directory
start_install_script() {
    echo -e "${WARNING}NOTE: Your are about to run this script in $PWD and the build files will also be downloaded here ${RESET_COLOR}"
    echo -e "${WARNING}      any build files will also be downloaded here ${RESET_COLOR}"
    echo -e "${WARNING}Recommended location: ~/Downloads/Builds ${RESET_COLOR}"
    echo -e "${INVERTED} - Do you wish to continue? [y/N] ${RESET_COLOR}"
    read response
    if [[ $response == "y" || $response == "Y" ]]; then
        return
    fi
    echo "Aborting script."
    exit 1
}

check_network() {
    if ! curl -s --head --request GET https://github.com > /dev/null; then
        echo -e "${ERROR}Error: No internet connection. Please check your network and try again. ${RESET_COLOR}"
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
        echo -e "${ERROR}Error: Failed to update username. Restoring backup... ${RESET_COLOR}"
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
    
    # Start with core programs that work on all platforms
    local computed_program_list="$programs_core"
    
    # Add desktop programs for desktop setup
    if [[ $setup_type == "desktop" || $setup_type == "desktop-full" ]]; then
        computed_program_list="$computed_program_list $programs_desktop"
        
        # Add full programs if requested choice was desktop-full
        if [[ $setup_type == "desktop-full" ]]; then
            computed_program_list="$computed_program_list $programs_full"
        fi
    fi
    
    # Add platform-specific programs
    if [[ $platform == "macos" ]]; then
        computed_program_list="$computed_program_list $programs_macos"
    fi
    
    echo "$computed_program_list"
}

# Function to get dotfiles list based on setup type
get_dotfiles_list() {
    local setup_type="$1"
    
    local common_dotfiles=".gitconfig .gitignore_global .zshrc .vimrc .config/btop/btop.conf .config/btop/themes/perox-enurple.theme .tmux.conf .config/nvim/init.lua .config/lf/lfrc .config/lf/previewer.sh"
    
    if [[ $setup_type == "desktop" || $setup_type == "desktop-full" ]]; then
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
    local pm="$2"
    
    local package_name=$(get_package_name "$program" "$pm")
    
    if [[ "$package_name" == "MANUAL" ]]; then
        return 0  # true - needs custom installer
    fi
    
    return 1  # false - use package manager
}

# Function to choose what sort of setup to run for installer
# Note: For headless server no terminal emulator should be installed (alacritty and wezterm), and installing the font is not necessary
setup_type() {
    if [ -f .env ]; then
        source .env
        setup=$SETUP_SCRIPT_ENV
        echo -e "\n${INVERTED}##### Found $setup env in your setup! #####${RESET_COLOR}"
    else
        echo -e "${INVERTED}### Choose your setup type: ${RESET_COLOR}"
        echo -e "  ${GREEN}1${RESET_COLOR}) Desktop + Full programs (includes heavy programs like fastfetch, cava, wezterm)"
        echo -e "  ${GREEN}2${RESET_COLOR}) Desktop (full setup with GUI programs)"
        echo -e "  ${GREEN}3${RESET_COLOR}) Server (minimal setup without GUI)"
        echo ""
        echo -e "${YELLOW}Enter choice [1-3]: ${RESET_COLOR}"
        
        read choice
        case $choice in
            1)
                setup="desktop-full"
                ;;
            2)
                setup="desktop"
                ;;
            3)
                setup="server"
                ;;
            *)
                echo -e "${RED}Invalid choice. Defaulting to server.${RESET_COLOR}"
                setup="server"
                ;;
        esac
    fi

    # Set platform and update program/dotfile lists
    platform=$(detect_platform)
    programs_list=$(get_programs_list "$platform" "$setup")
    dotfiles_list=$(get_dotfiles_list "$setup")

    if [[ $setup == "desktop" || $setup == "desktop-full" ]]; then
        echo -e "\n${INVERTED}##### Running $setup version of the script! #####${RESET_COLOR}"
    elif [[ $setup == "server" ]]; then
        echo -e "\n${INVERTED}##### Running $setup version of the script! #####${RESET_COLOR}"
    else
        echo -e "${ERROR}Error: Invalid option. Please run the script again and choose either 'desktop' or 'server'. Exiting... ${RESET_COLOR}"
        exit 1
    fi
}

# Function to create a directory
create_directory() {
    dir=$1
    if [ ! -d "$dir" ]; then
        mkdir -p "$dir"
        if [ ! -d "$dir" ]; then
            echo -e "${ERROR}Error: Failed to create directory. Exiting... ${RESET_COLOR}"
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
        echo -e "${ERROR}Error: Directory does not exist. Exiting... ${RESET_COLOR}"
        exit 1
    fi
}

# Function to clone or update the repository
clone_or_update_repo() {
    if [ ! -d "dotfiles" ]; then
        git clone https://github.com/$username/dotfiles.git
        if [ $? -ne 0 ]; then
            echo -e "${ERROR}Error: Failed to clone repository, check internet connection, make sure you have git installed, that the repo exists or that you have the right permissions set then try again. Exiting... ${RESET_COLOR}"
            exit 1
        fi
        cd dotfiles
        echo "SETUP_SCRIPT_ENV=$setup" > .env
    else
        cd dotfiles
        git pull
        if [ $? -ne 0 ] && [ $testing -ne 0 ]; then
            echo -e "${ERROR}Error: Failed to update repository, check internet connection, make sure you have git installed, that the repo exists or that you have the right permissions set then try again. Exiting... ${RESET_COLOR}"
            exit 1
        fi
        echo "SETUP_SCRIPT_ENV=$setup" > .env
    fi
}

# Function to change .gitconfig file after cloning or updating the repo
change_gitconfig() {
    if [ -f .gitconfig.backup ]; then
        echo -e "${WARNING}NOTE: You probably already ran the install script and changed the .gitconfig file! ${RESET_COLOR}"
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
        echo -e "\n${INVERTED}### You already have ~/Development/$username dir, going \$HOME(~/) ${RESET_COLOR}"
        cd "$HOME"
    else
        echo -e "${INVERTED}### Would you like to create a new Development directory ~/Development/$username? [y/n] ${RESET_COLOR}"
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
            * ) echo -e "${ERROR}Error: Please answer yes or no, retry the script. Exiting... ${RESET_COLOR}"
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
        echo -e "${ERROR}Error: Run this from the dotfiles repo ${RESET_COLOR}"
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
            echo -e "\033[41mError: Failed to make directory for $file! ${RESET_COLOR}"
        else
            echo "Made directory: $HOME/$(dirname $file)"
        fi
    fi
    cp "$file" "$HOME/$file"
    if [ $? -ne 0 ]; then
        echo -e "${ERROR}Error: Failed to copy file locally! ${RESET_COLOR}"
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
        echo -e "${INVERTED}### $file files are identical ${RESET_COLOR}"
    elif [ $cmpResult -eq 1 ];then
        echo -e "${INVERTED}### $file files are different ${RESET_COLOR}"
        view_differences "$file"
        replace_files "$file" "$cmpResult" "replace"
    else
        echo -e "${INVERTED}### The local file ~/$file does not exist! ${RESET_COLOR}"
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
        echo -e "${INVERTED}### Your Mac doesn't have brew, would you like to install it? [y/N] ${RESET_COLOR}"
        read yn
        if [[ $yn == "y" || $yn == "Y" ]]; then
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            echo >> $HOME/.zprofile
            echo 'eval "$(/opt/homebrew/bin/brew shellenv zsh)"' >> $HOME/.zprofile
            eval "$(/opt/homebrew/bin/brew shellenv zsh)"
            PM="brew"
        else
            echo -e "${WARNING}Note: Not using a package manager with this script might cause problems, skipping to dotfile replacement... ${RESET_COLOR}"
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
    elif command -v dnf &> /dev/null; then
        PM="dnf"
    elif command -v apk &> /dev/null; then
        PM="apk"
    elif command -v apt &> /dev/null; then
        PM="apt"
    else
        echo -e "${ERROR}Error: No supported package manager found. Exiting... ${RESET_COLOR}"
        exit 1
    fi
    echo -e "${INVERTED}#### Your package manager is set to $PM #### ${RESET_COLOR}"
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
        *) echo -e "${WARNING}NOTE: Package manager not yet supported ${RESET_COLOR}";;
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
        *) echo -e "${WARNING}NOTE: Package manager not yet supported ${RESET_COLOR}";;
    esac
}

# Install yazi file manager by downloading the appropriate binary for the system architecture
yazi_installer() {
    curl -fLo "yazi-$arch-unknown-linux-gnu.zip" "https://github.com/sxyazi/yazi/releases/latest/download/yazi-$arch-unknown-linux-gnu.zip"
    unzip "yazi-$arch-unknown-linux-gnu.zip"
    cd yazi-$arch-unknown-linux-gnu
    mkdir -p $HOME/.local/bin/
    cp yazi $HOME/.local/bin
    cd $current_path
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
    local platform=$(detect_platform)
    
    for program in $programs_list
    do
        local command_name=$(get_program_command "$program")
        local package_name=$(get_package_name "$program" "$PM")

        if command -v $command_name &> /dev/null; then
            echo -e "${INVERTED}### You already have $program installed ${RESET_COLOR}"
        elif [[ $device == "Android" && ( $program == "alacritty" || $program == "wezterm"  || $program == "cava" ) ]]; then
            echo "Skipping $program on Android" &> /dev/null
        else
            echo -e "${INVERTED}### Would you like to install $program? [y/N] ${RESET_COLOR}"
            read yn
            case $yn in
                [Yy]* ) 
                    if needs_custom_installer "$program" "$PM"; then
                        case $program in
                            "nvim") neovim_installer ;;
                            "alacritty") alacritty_installer ;;
                            "yazi") yazi_installer ;;
                            "zellij") zellij_installer ;;
                            "wezterm") wezterm_installer ;;
                            "chafa") chafa_installer ;;
                        esac
                    else
                        if [[ $PM == "brew" || $PM == "pkg" ]]; then
                            $PM install $package_name
                        else
                            sudo $PM install $package_name
                        fi
                        
                        if [ $? -ne 0 ]; then
                            echo -e "${ERROR}Error: Failed to install $program with $PM ${RESET_COLOR}"
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
        echo -e "${INVERTED}### Do you want to change your shell to zsh? (most things in this script won't work if you don't) [Y/n] ${RESET_COLOR}"
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
        echo -e "${INVERTED}### You already have $nerd_font Nerd Font installed ${RESET_COLOR}"
    elif [[ $PM == 'brew' ]]; then
        echo -e "${INVERTED}### Installing $nerd_font Nerd Font ${RESET_COLOR}"
        brew install --cask font-$nerd_font_package-nerd-font
    else
        echo -e "${INVERTED}### Downloading and installing $nerd_font Nerd Font ${RESET_COLOR}"
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

    echo -e "${INVERTED}### Would you like to change the default username ($username) for this script? [y/N] ${RESET_COLOR}"
    read yn
    case $yn in
        [Yy]* )
            read -p "Enter your GitHub username: " new_username
            update_username "$new_username"
            echo -e "\033[43mNOTE: Username updated. Please rerun the script for changes to take effect: ./install.sh ${RESET_COLOR}"
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
    if [[ $setup == "desktop" || $setup == "desktop-full" ]]; then
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
