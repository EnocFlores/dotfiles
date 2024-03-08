#!/bin/bash

# This script will install necessary programs to setup and use these dotfiles, then it will replace your dotfiles

{
# Save the architecture, OS, and device of user
arch=$(uname -m)
os=$(uname -s)
device=$(uname -o)

# Check for package manager
if command -v brew &> /dev/null; then
    PM="brew"
elif [ "$device" = "Android" ]; then
    PM="pkg"
elif command -v apt &> /dev/null; then
    PM="apt"
else
    echo "No supported package manager found. Exiting."
    exit 1
fi

echo "Your package manager is set to $PM"

# Ask user to install programs
for program in alacritty git zsh tmux vim 
do
    if command -v $program &> /dev/null; then
        echo "You already have $program installed"
    else
        read -p "Would you like to install $program? (y/n) " yn
        case $yn in
            [Yy]* ) $PM install $program;;
            [Nn]* ) echo "Skipping $program.";;
            * ) echo "Please answer yes or no.";;
        esac
    fi
done

# Neovim is a special case, where depending on where you are installing it from then you will have to use your package manager, appimage, or compile it
if command -v nvim &> /dev/null; then
    echo "You already have neovim installed"
else
    read -p "Would you like to install neovim? (y/N) " yn
    if [[ $yn == "y" || $yn == "Y" ]]; then
        case $PM in
            "brew") $PM install neovim;;
            "pkg") $PM install neovim;;
            "apt")
                curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
                chmod u+x nvim.appimage
                mkdir -p /opt/nvim
                mv nvim.appimage /opt/nvim/nvim
                ;;
            *) echo "Package manager not yet supported"
        esac
    fi
fi

# Ask user if the creating of a Development branch is okay, and if not they shall input one
# Ask user for directory to clone into
if [ -d "$HOME/Development/EnocFlores" ]; then
    echo "You already have ~/Development/EnocFlores dir, changing into there"
    cd "$HOME/Development/EnocFlores"
else
    read -p "Would you like to create a new directory ~/Development/EnocFlores for the dotfiles? (y/n) " yn
    case $yn in
        [Yy]* ) 
            cd ~
            if [ ! -d "Development" ]; then
                mkdir Development
            fi
            cd Development
            if [ ! -d "EnocFlores" ]; then
                mkdir EnocFlores
            fi
            cd EnocFlores;;
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
        * ) echo "Please answer yes or no."
            exit 1;;
    esac
fi

# Clone the repository
if [ ! -d "dotfiles" ]; then
  git clone https://github.com/EnocFlores/dotfiles.git
fi
cd dotfiles


# Ask user to copy dotfiles to home directory
for file in .zshrc .vimrc .tmux.conf .config/alacritty/alacritty.toml .config/nvim/init.lua
do
    if cmp -s "$HOME/$file" "$file"; then
        echo "### $file files are identical"
    else
        echo "### $file files are different"
        read -p " -  Do you want to view the differences? (Y/n) " choice
        if [[ $choice != "n" && $choice != "N" ]]; then
            colordiff "$HOME/$file" "$file"
            read -p " -  Do you want to edit the differences in vimdiff? (y/N) " edit_choice
            if [[ $edit_choice == "y" || $edit_choice == "Y" ]]; then
                echo " -  Your local file is on the left, the remote file is on the right"
                read -p " -   -  Press enter to continue"
                vimdiff "$HOME/$file" "$file"
            fi
        fi
        read -p " -  Do you want to replace your local $file with the remote one? (y/N) " replace_choice
        if [[ $replace_choice == "y" || $replace_choice == "Y" ]]; then
            read -p " -  Do you want to make a backup of your local $file? (Y/n) " backup_choice
            if [[ $backup_choice != "n" && $backup_choice != "N" ]]; then
                cp "$HOME/$file" "$HOME/$file.backup"
                echo " -  Backup of local $file has been created at $HOME/$file.backup"
            fi
            cp "$file" "$HOME/$file"
            echo " -  Local $file has been replaced with the remote one."
        fi
    fi
done
}
