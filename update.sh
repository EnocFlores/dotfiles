#!/bin/bash

# Now that you have this repository cloned, you can update your configs to the latest changes of the remote repository

{
# First, check for differences in the local dotfiles to the remote dotfiles
# Second, ask the user if they would like to view the differences
# Third, ash the user if they would like to replace their dotfiles with remote dotfiles
current_dir=$(basename "$(pwd)")
if [ "$current_dir" != "dotfiles" ]; then
    echo "Run this from the dotfiles repo"
    exit 1
fi

git pull

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
