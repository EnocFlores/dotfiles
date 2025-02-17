#!/bin/bash
# EnocFlores <https://github.com/EnocFlores>
# Last Change: 2024.04.26



# Now that you have this repository cloned, you can update your configs to the latest changes of the remote repository

{
# First, check for differences in the local dotfiles to the remote dotfiles
# Second, ask the user if they would like to view the differences
# Third, ask the user if they would like to replace their dotfiles with remote dotfiles

source install.sh

check_directory
git pull
setup_type
echo "SETUP_SCRIPT_ENV=$setup" > .env

for file in $(get_dotfiles)
do
    cmpResult=$(compare_files "$file")
    handle_differences "$file" "$cmpResult"
done
}
