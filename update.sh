#!/bin/bash
# EnocFlores <https://github.com/EnocFlores>
# Last Change: 2024.03.19



# Now that you have this repository cloned, you can update your configs to the latest changes of the remote repository

{
# First, check for differences in the local dotfiles to the remote dotfiles
# Second, ask the user if they would like to view the differences
# Third, ask the user if they would like to replace their dotfiles with remote dotfiles
current_dir=$(basename "$(pwd)")
if [ "$current_dir" != "dotfiles" ]; then
    echo -e "\033[41m\033[1m\033[37mError: Run this from the dotfiles repo \033[0m"
    exit 1
fi

dotfiles_list='.gitconfig .gitignore_global .zshrc .vimrc .config/btop/btop.conf .config/btop/themes/perox-enurple.theme .tmux.conf .config/nvim/init.lua .config/lf/lfrc .config/lf/previewer.sh .config/alacritty/alacritty.toml .config/zellij/config.kdl .config/wezterm/wezterm.lua'

git pull

for file in $dotfiles_list
do
    cmp -s "$HOME/$file" "$file"
    cmpResult=$?
    if [ $cmpResult -eq 0 ]; then
        echo -e "\033[7m\033[1m### $file files are identical \033[0m"
        continue
    elif [ $cmpResult -eq 1 ];then
        echo -e "\033[7m\033[1m### $file files are different \033[0m"
        read -p " -  Do you want to view the differences? [Y/n] " choice
        if [[ $choice != "n" && $choice != "N" ]]; then
            diff --color "$HOME/$file" "$file"
            read -p " -  Do you want to edit the differences in vimdiff? [y/N] " edit_choice
            if [[ $edit_choice == "y" || $edit_choice == "Y" ]]; then
                echo " -  Your local file is on the left, the remote file is on the right"
                read -p " -   -  Press enter to continue"
                vimdiff "$HOME/$file" "$file"
            fi
        fi
    else
        echo -e "\033[7m\033[1m### The local file ~/$file does not exist! \033[0m"
    fi
    read -p " -  Do you want to replace/create your local ~/$file with the remote one? [y/N] " replace_choice
    if [[ $replace_choice == "y" || $replace_choice == "Y" ]]; then
        if [ $cmpResult -ne 2 ];then
            read -p " -  Do you want to make a backup of your local $file? [Y/n] " backup_choice
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
