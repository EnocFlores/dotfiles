#!/bin/bash
# EnocFlores <https://github.com/EnocFlores>
# Last Change: 2024.03.19



# This script will install/check necessary programs to setup and use these dotfiles

{
# If you fork the repo, then these variables make it easy to change this script for your own Github
username="EnocFlores"
email="EnocFlores@github.com"

# Note the architecture, OS, and device of user
arch=$(uname -m)
os=$(uname -s)
device=$(uname -o)

# programs and dotfiles variables for easy access
programs_list='curl git zsh neofetch vim btop tmux neovim lf chafa alacritty zellij wezterm'

# ! TESTING ! A method to use dirname and basename to install programs that have a different package name than their command name, so far it is just one so not investing the time to get this working yet, just an idea
special_snowflake_list='neovim/nvim'

dotfiles_list='.gitconfig .gitignore_global .zshrc .vimrc .config/btop/btop.conf .tmux.conf .config/nvim/init.lua .config/lf/lfrc .config/lf/previewer.sh .config/alacritty/alacritty.toml .config/zellij/config.kdl .config/wezterm/wezterm.lua'
nerd_font='RobotoMono'
nerd_font_package='roboto-mono'

# Change .gitconfig file after cloning or updating the repo
change_gitconfig() {
    if [ -f .gitconfig.backup ]; then
        echo -e "\033[43mNOTE: You probably already ran the install script and changed the .gitconfig file! \033[0m"
        return
    fi
    sed -i".backup" -e "s/GIT_NAME/$username/g" .gitconfig
    if [ $? -eq 0 ];then
        echo " -  successfully changed .gitconfig name to $username"
    fi
    sed -i".trash" -e "s/GIT_EMAIL/$email/g" .gitconfig
    if [ $? -eq 0 ];then
        echo " -  successfully changed .gitconfig name to $email"
    fi
}

# Replace dotfiles function, establishes the directory to clone the dotfiles into, clones the dotfiles, and replaces the dotfiles in the home directory
replace_dotfiles() {
    # Ask user if the creating of a Development branch is okay, otherwise they can choose the directory they want to clone repo into
    if [ -d "$HOME/Development/$username" ]; then
        echo -e "\n\033[7m\033[1m### You already have ~/Development/$username dir, changing into there \033[0m"
        cd "$HOME/Development/$username"
    else
        read -p "Would you like to create a new directory ~/Development/$username for the dotfiles? (y/n) " yn
        case $yn in
            [Yy]* ) 
                cd $HOME
                if [ ! -d "Development" ]; then
                    mkdir Development
                    if [ ! -d "Development" ]; then
                        echo -e "\033[41m\033[1m\033[37mError: Failed to create directory. Exiting. \033[0m"
                        exit 1
                    fi
                fi
                cd Development
                if [ ! -d $username ]; then
                    mkdir $username
                    if [ ! -d $username ]; then
                        echo -e "\033[41m\033[1m\033[37mError: Failed to create directory. Exiting. \033[0m"
                        exit 1
                    fi
                fi
                cd $username;;
            [Nn]* ) 
                read -p "Please enter the full path of the existing directory where you'd like to clone the dotfiles: " dir
                if [ -d "$dir" ]; then
                    cd "$dir"
                elif [ -d "$HOME/$dir" ]; then
                    cd "$HOME/$dir"
                else
                    echo -e "\033[41m\033[1m\033[37mError: Directory does not exist. Exiting. \033[0m"
                    exit 1
                fi;;
            * ) echo -e "\033[41m\033[1m\033[37mError: Please answer yes or no, retry the script. Exiting. \033[0m"
                exit 1;;
        esac
    fi

    # Clone the repository and move into it, unless it already exists then move into it and update it
    if [ ! -d "dotfiles" ]; then
        git clone https://github.com/$username/dotfiles.git
        if [ $? -ne 0 ]; then
            echo -e "\033[41m\033[1m\033[37mError: Failed to clone repository, check internet connection, make sure you have git installed or that you have the right permissions set then try again. Exiting. \033[0m"
            exit 1
        fi
        cd dotfiles
    else
        cd dotfiles
        git pull
        if [ $? -ne 0 ]; then
            echo -e "\033[41m\033[1m\033[37mError: Failed to update repository, check internet connection, make sure you have git installed then try again. Exiting. \033[0m"
            exit 1
        fi
    fi

    change_gitconfig

    # Ask user to copy dotfiles to home directory
    for file in $dotfiles_list
    do
        cmp -s "$HOME/$file" "$file"
        cmpResult=$?
        if [ $cmpResult -eq 0 ]; then
            echo -e "\033[7m\033[1m### $file files are identical \033[0m"
            continue
        elif [ $cmpResult -eq 1 ];then
            echo -e "\033[7m\033[1m### $file files are different \033[0m"
            read -p " -  Do you want to view the differences? (Y/n) " choice
            if [[ $choice != "n" && $choice != "N" ]]; then
                diff --color "$HOME/$file" "$file"
                read -p " -  Do you want to edit the differences in vimdiff? (y/N) " edit_choice
                if [[ $edit_choice == "y" || $edit_choice == "Y" ]]; then
                    echo " -  Your local file is on the left, the remote file is on the right"
                    read -p " -   -  Press enter to continue"
                    vimdiff "$HOME/$file" "$file"
                fi
            fi
        else
            echo -e "\033[7m\033[1m### The local file ~/$file does not exist! \033[0m"
        fi
        read -p " -  Do you want to replace/create your local ~/$file with the remote one? (y/N) " replace_choice
        if [[ $replace_choice == "y" || $replace_choice == "Y" ]]; then
            if [ $cmpResult -ne 2 ];then
                read -p " -  Do you want to make a backup of your local $file? (Y/n) " backup_choice
                if [[ $backup_choice != "n" && $backup_choice != "N" ]]; then
                    cp "$HOME/$file" "$HOME/$file.backup"
                    echo " -  Backup of local ~/$file has been created at $HOME/$file.backup"
                fi
            fi
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
            echo " -  Local ~/$file has been replaced with the remote one."
        fi
    done
}

# Install Homebrew on Mac if it is not already installed
brew_on_mac() {
    if command -v brew &> /dev/null; then
        PM="brew"
    else
        read -p "Your Mac doesn't have brew, would you like to install it? (y/N)" yn
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

# Check for other package managers
assign_package_manager() {
    if [[ $os == "Darwin" ]]; then
        brew_on_mac
    elif [[ "$device" = "Android" ]]; then
        PM="pkg"
    elif command -v apt &> /dev/null; then
        PM="apt"
    else
        echo -e "\033[41m\033[1m\033[37mError: No supported package manager found. Exiting. \033[0m"
        exit 1
    fi
    echo -e "\033[7m\033[1m##### Your package manager is set to $PM ##### \033[0m"
}

# Alacritty and Neovim is a special case, where depending on where you are installing it from then you will have to use your package manager, appimage, or compile it
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
            ;;
        *) echo -e "\033[43mNOTE: Package manager not yet supported \033[0m"
    esac
}

# Install neovim app image
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
                sudo mv neovim /usr/local/bin
                cd $HOME
            fi
            ;;
        *) echo -e "\033[43mNOTE: Package manager not yet supported \033[0m"
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
    curl -LO https://github.com/wez/wezterm/releases/download/20240203-110809-5046fc22/wezterm-20240203-110809-5046fc22-src.tar.gz
    tar -xzf wezterm-20240203-110809-5046fc22-src.tar.gz
    cd wezterm-20240203-110809-5046fc22
    ./get-deps
    cargo build --release
    cargo run --release --bin wezterm -- start
    sudo ln -s target/release/wezterm /usr/local/bin/wezterm
    sudo cp assets/icon/wezterm-icon.svg /usr/share/pixmaps/WezTerm.svg
    sed -i" " -e "s/org.wezfurlong.wezterm/WezTerm/g" assets/wezterm.desktop
    sudo desktop-file-install assets/wezterm.desktop
    sudo update-desktop-database
}

# Ask user to install widely availble programs
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
                read -p "Would you like to install $program? (y/N) " yn
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
            read -p "Would you like to install $program? (y/N) " yn
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

# Install Nerd Font
nerd_font_installer() {
    fc-list | grep "$nerd_font Nerd Font Mono" > /dev/null
    if [ $? -eq 0 ]; then
        echo -e "\033[7m\033[1m### You already have $nerd_font Nerd Font installed \033[0m"
    elif [[ $PM == 'brew' ]]; then
        brew tap homebrew/cask-fonts &&
        brew install --cask font-$nerd_font_package-nerd-font
    else
        curl -fLo "$nerd_font.tar.xz" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/$nerd_font.tar.xz"
        tar -xf $nerd_font.tar.xz
        if [ ! -d $HOME/.fonts ];then
            mkdir -p $HOME/.fonts
        fi
        mv *.ttf $HOME/.fonts/
        fc-cache -f -v
    fi
}

# Run functions in order
assign_package_manager

programs_installer

nerd_font_installer

replace_dotfiles

exit 0
}
