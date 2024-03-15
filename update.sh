#!/bin/bash

# Now that you have this repository cloned, you can update your configs to the latest changes of the remote repository

{
# First, check for differences in the local dotfiles to the remote dotfiles
# Second, ask the user if they would like to view the differences
# Third, ask the user if they would like to replace their dotfiles with remote dotfiles
current_dir=$(basename "$(pwd)")
if [ "$current_dir" != "dotfiles" ]; then
    echo "Run this from the dotfiles repo"
    exit 1
fi

dotfiles_list='.zshrc .gitconfig .gitignore_global .tmux.conf .vimrc .config/alacritty/alacritty.toml .config/nvim/init.lua .config/lf/lfrc .config/zellij/config.kdl .config/wezterm/wezterm.lua'

git pull

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
