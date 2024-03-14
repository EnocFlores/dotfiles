#!/bin/bash
# This script will install/check necessary programs to setup and use these dotfiles, then it will replace your dotfiles

{
# If you fork the repo and decide to change this script to fit your own Github then change this variable to your github username:
username="EnocFlores"

# Note the architecture, OS, and device of user
arch=$(uname -m)
os=$(uname -s)
device=$(uname -o)

# programs and dotfiles variables for easy access
programs_list='alacritty git zsh neofetch tmux vim neovim'
dotfiles_list='.zshrc .gitconfig .gitignore_global .vimrc .tmux.conf .config/alacritty/alacritty.toml .config/nvim/init.lua'

# Replace dotfiles function, establishes the directory to clone the dotfiles into, clones the dotfiles, and replaces the dotfiles in the home directory
replace_dotfiles() {
    # Ask user if the creating of a Development branch is okay, otherwise they can choose the directory they want to clone repo into
    if [ -d "$HOME/Development/$username" ]; then
        echo "You already have ~/Development/$username dir, changing into there"
        cd "$HOME/Development/$username"
    else
        read -p "Would you like to create a new directory ~/Development/$username for the dotfiles? (y/n) " yn
        case $yn in
            [Yy]* ) 
                cd $HOME
                if [ ! -d "Development" ]; then
                    mkdir Development
                    if [ ! -d "Development" ]; then
                        echo "Failed to create directory. Exiting."
                        exit 1
                    fi
                fi
                cd Development
                if [ ! -d $username ]; then
                    mkdir $username
                    if [ ! -d $username ]; then
                        echo "Failed to create directory. Exiting."
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
                    echo "Directory does not exist. Exiting."
                    exit 1
                fi;;
            * ) echo "Please answer yes or no, retry the script. Exiting."
                exit 1;;
        esac
    fi

    # Clone the repository and move into it, unless it already exists then move into it and update it
    if [ ! -d "dotfiles" ]; then
        git clone https://github.com/$username/dotfiles.git
        if [ $? -ne 0 ]; then
            echo "Failed to clone repository, check internet connection, make sure you have git installed then try again. Exiting."
            exit 1
        fi
        cd dotfiles
    else
        cd dotfiles
        git pull
        if [ $? -ne 0 ]; then
            echo "Failed to update repository, check internet connection, make sure you have git installed then try again. Exiting."
            exit 1
        fi
    fi

    # Ask user to copy dotfiles to home directory
    for file in $dotfiles_list
    do
        cmp -s "$HOME/$file" "$file"
        cmpResult=$?
        if [ $cmpResult -eq 0 ]; then
            echo "### $file files are identical"
            continue
        elif [ $cmpResult -eq 1 ];then
            echo "### $file files are different"
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
            echo "### The local file ~/$file does not exist!"
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
                    echo "Failed to make directory for $file!"
                else
                    echo "Made directory: $HOME/$(dirname $file)"
                fi
            fi
            cp "$file" "$HOME/$file"
            if [ $? -ne 0 ]; then
                echo "Failed to copy file locally!"
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
            echo "Not using a package manager with this script might cause problems, skipping to dotfile replacement..."
            replace_dotfiles
            exit 0
        fi
    fi
}

# command -v brewster &> /dev/null
# hasBrew=$?
# if [ $hasBrew -eq 0 ]; then
#     echo "Has brew!"
# else
#     echo "No Brew"
# fi

# Check for other package managers
if [[ $os == "Darwin" ]]; then
    brew_on_mac
elif [[ "$device" = "Android" ]]; then
    PM="pkg"
elif command -v apt &> /dev/null; then
    PM="apt"
else
    echo "No supported package manager found. Exiting."
    exit 1
fi

echo "Your package manager is set to $PM"

# Alacritty and Neovim is a special case, where depending on where you are installing it from then you will have to use your package manager, appimage, or compile it
alacritty_installer() {
    case $PM in
        "brew") $PM install alacritty;;
        "apt")
            sudo apt install cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3 gzip scdoc
            git clone https://github.com/alacritty/alacritty.git
            cd alacritty
            if [ ! command -v cargo &> /dev/null ]; then
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
        *) echo "Package manager not yet supported"
    esac
}

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
                cd $HOME
            fi
            ;;
        *) echo "Package manager not yet supported"
    esac
}

# Ask user to install widely availble programs
# for program in alacritty git zsh tmux vim neovim
for program in $programs_list
do
    if command -v $program &> /dev/null; then
        echo "You already have $program installed"
    elif [[ $program == "neovim" ]]; then
        # neovim has a different program name, so we want to catch this before the other programs that command is the same name as their package
        if command -v nvim &> /dev/null; then
            echo "You already have $program installed"
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
    elif [[ $device == "Android" && ( $program == "alacritty" || $program == "kitty" ) ]]; then
        echo "Skip!" &> /dev/null
    else
        read -p "Would you like to install $program? (y/N) " yn
        case $yn in
            [Yy]* ) 
                if [[ $PM == "brew" || $PM == "pkg" ]]; then
                    $PM install $program
                    if [ $? -ne 0 ]; then
                        echo "Failed to install $program with $PM"
                        exit 1
                    fi
                elif [[ $program == "alacritty" ]]; then
                    alacritty_installer
                else
                    sudo $PM install $program
                    if [ $? -ne 0 ]; then
                        echo "Failed to install $program with $PM"
                        exit 1
                    fi
                fi
                ;;
            [Nn]* ) echo "Skipping $program.";;
            * ) echo "Please answer yes or no.";;
        esac
    fi
done

# Install Nerd Font

fc-list | grep 'RobotoMono Nerd Font Mono' > /dev/null
if [ $? -eq 0 ]; then
    echo "You already have Nerd Font installed"
elif [[ $PM == 'brew' ]]; then
    brew tap homebrew/cask-fonts &&
    brew install --cask font-roboto-mono-nerd-font
else
    cd $HOME/Downloads
    if [ $? -ne 0 ]; then
        echo "You do not have a Downloads directory, can not install font"
        exit 1
    fi
    curl -fLo "RobotoMono.tar.xz" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/RobotoMono.tar.xz"
    tar -xf RobotoMono.tar.xz
    if [ ! -d $HOME/.fonts ];then
        mkdir -p $HOME/.fonts
    fi
    mv *.ttf $HOME/.fonts/
    fc-cache -f -v
fi

replace_dotfiles

exit 0
}
