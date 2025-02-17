#!/bin/bash
# EnocFlores <https://github.com/EnocFlores>
# Last Change: 2024.04.26



# This script will install/check necessary programs to setup and use these dotfiles

{
testing=1
# If you fork the repo, then these variables make it easy to change this script for your own Github, make sure to replace this with your actual Github username
username="EnocFlores"
email="${username}@users.noreply.github.com"

# Note the architecture, OS, device, and current path of the user
arch=$(uname -m)
os=$(uname -s)
device=$(uname -o)
current_path=$(pwd)

# programs and dotfiles variables for easy access
programs_list='curl git jq zsh chafa neofetch vim btop tmux neovim lf cava alacritty zellij wezterm'

# ! TESTING ! A method to use dirname and basename to install programs that have a different package name than their command name, so far it is just one so not investing the time to get this working yet, just an idea, but this might also later be used to specify how the application can be installed
special_snowflake_list='curl/curl git/git jq/jq zsh/zsh chafa/chafa neofetch/neofetch vim/vim btop/btop tmux/tmux neovim/nvim lf/lf alacritty/alacritty zellij/zellij wezterm/wezterm'

dotfiles_list='.gitconfig .gitignore_global .zshrc .vimrc .config/btop/btop.conf .config/btop/themes/perox-enurple.theme .tmux.conf .config/nvim/init.lua .config/lf/lfrc .config/lf/previewer.sh .config/cava/config .config/alacritty/alacritty.toml .config/wezterm/wezterm.lua .config/yazi/theme.toml .config/zellij/config.kdl .config/kmonad.kdb'
nerd_font='RobotoMono'
nerd_font_package='roboto-mono'

setup="desktop"

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

# Function to choose what sort of setup to run for installer
# Note: For headless server no terminal emulator should be installed (alacritty and wezterm), and installing the font is not necessary
setup_type() {
    if [ -f .env ]; then
        source .env
        setup=$SETUP_SCRIPT_ENV
        echo -e "\n\033[7m\033[1m##### Running $setup version of the script! #####\033[0m"
    else
        echo "Do you want to run a full desktop setup or a server setup? [desktop/server]"
        read setup
    fi
    if [[ $setup == "desktop" ]]; then
        setup="desktop"
        echo -e "\n\033[7m\033[1m##### Running $setup version of the script! #####\033[0m"
    elif [[ $setup == "server" ]]; then
        setup="server"
        programs_list='curl git jq zsh chafa neofetch vim btop tmux neovim lf'
        dotfiles_list='.gitconfig .gitignore_global .zshrc .vimrc .config/btop/btop.conf .config/btop/themes/perox-enurple.theme .tmux.conf .config/nvim/init.lua .config/lf/lfrc .config/lf/previewer.sh'
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
        echo -e "\033[43mNOTE: You probably already ran the install script and changed the .gitconfig file! \033[0m"
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
                change_directory $HOME;;
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

# Function to get dotfiles
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
    read -p " -  Do you want to $goal your local ~/$file with the remote one? [y/N] " replace_choice
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

# Function to install Homebrew on Mac if it is not already installed
brew_on_mac() {
    if command -v brew &> /dev/null; then
        PM="brew"
    else
        echo -e "\033[7m\033[1m### Your Mac doesn't have brew, would you like to install it? [y/N] \033[0m"
        read yn
        if [[ $yn == "y" || $yn == "Y" ]]; then
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            PM="brew"
        else
            echo -e "\033[43mNote: Not using a package manager with this script might cause problems, skipping to dotfile replacement... \033[0m"
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

# NOTE: The installers for the programs below are because for some of these programs we need the latest version of this is the only way to install them, it can vary from using your package manager, using an appimage, or compiling the program from source
# Build alacritty from source
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
        *) echo -e "\033[43mNOTE: Package manager not yet supported \033[0m";;
    esac
}

# Install neovim app image or if arm then build from source
neovim_installer() {
    case $PM in
        "brew") $PM install neovim;;
        "pkg") $PM install neovim;;
        "apt")
            if [[ $arch = "x86_64" ]]; then
                curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
                chmod u+x nvim.appimage
                sudo mkdir -p /opt/nvim
                sudo mv nvim.appimage /opt/nvim/nvim
            else
                sudo apt-get install ninja-build gettext cmake unzip curl
                git clone https://github.com/neovim/neovim
                cd neovim && make CMAKE_BUILD_TYPE=Release
                sudo make install
                sudo mv build/bin/nvim /usr/local/bin/
                cd $current_path
            fi
            ;;
        *) echo -e "\033[43mNOTE: Package manager not yet supported \033[0m";;
    esac
}

# Install lf binary
lf_installer() {
    if [[ $arch = "x86_64" ]];then
        lf_os="amd64"
    elif [[ $arch = "aarch64" ]];then
        lf_os="arm64"
    else
        echo -e "\033[43mNOTE: Architecture not supported by this script at this time, skipping... \033[0m"
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
        curl https://sh.rustup.rs -sSf | sh -s
        . $HOME/.cargo/env
    fi
    github_version=$(curl --silent "https://api.github.com/repos/wez/wezterm/releases/latest" | jq -r .tag_name)
    curl -LO https://github.com/wez/wezterm/releases/download/20240203-110809-5046fc22/wezterm-20240203-110809-5046fc22-src.tar.gz
    tar -xzf wezterm-20240203-110809-5046fc22-src.tar.gz
    cd wezterm-20240203-110809-5046fc22
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
    sudo rm /usr/loca/bin/chafa
    sudo ln -s $PWD/tools/chafa/chafa /usr/local/bin/chafa
    cd $current_path
}

# Ask user to install programs
programs_installer() {
    for program in $programs_list
    do
        if command -v $program &> /dev/null; then
            echo -e "\033[7m\033[1m### You already have $program installed \033[0m"
        elif [[ $program == "neovim" ]]; then
            # neovim has a different program name, so we want to catch this before the other programs that command is the same name as their package
            if command -v nvim &> /dev/null; then
                echo -e "\033[7m\033[1m### You already have $program installed \033[0m"
            else
                echo -e "\033[7m\033[1m### Would you like to install $program? [y/N] \033[0m"
                read yn
                case $yn in
                    [Yy]* ) 
                        neovim_installer
                        ;;
                    [Nn]* ) echo "Skipping $program.";;
                    * ) echo "Please answer yes or no.";;
                esac
            fi
        elif [[ $device == "Android" && ( $program == "alacritty" || $program == "wezterm"  || $program == "btop" ) ]]; then
            echo "Skip!" &> /dev/null
        else
            echo -e "\033[7m\033[1m### Would you like to install $program? [y/N] \033[0m"
            read yn
            case $yn in
                [Yy]* ) 
                    if [[ $PM == "brew" || $PM == "pkg" ]]; then
                        $PM install $program
                        if [ $? -ne 0 ]; then
                            echo -e "\033[41m\033[1m\033[37mError: Failed to install $program with $PM \033[0m"
                            exit 1
                        fi
                    elif [[ $program == "alacritty" ]]; then
                        alacritty_installer
                    elif [[ $program == "lf" ]]; then
                        lf_installer
                    elif [[ $program == "zellij" ]]; then
                        zellij_installer
                    elif [[ $program == "wezterm" ]]; then
                        wezterm_installer
                    elif [[ $program == "chafa" ]]; then
                        chafa_installer
                    else
                        sudo $PM install $program
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
        brew tap homebrew/cask-fonts &&
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

# Run functions in order
install_script() {
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

    setup_type
    assign_package_manager

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
