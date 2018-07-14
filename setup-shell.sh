#!/usr/bin/env bash
# This is a legacy script
set -o errexit

printmsg() {
	echo -e "\nsetup-shell.sh: ${1}\n"
}

# Install
printmsg 'Need to install some packages'
sudo apt install zsh wget git terminator

# Backup ~/.zshrc
printmsg 'Backing up ~/.zshrc to ~/.zshrc_backup'
mv --verbose --interactive "${HOME}/.zshrc" "${HOME}/.zshrc_backup"

# Powerline fonts
printmsg 'Installing powerline fonts'
git clone https://github.com/powerline/fonts ${HOME}/fonts
cd "${HOME}/fonts"; ./install.sh; cd "${HOME}"
rm -rf "${HOME}/fonts"

# Awesome fonts
printmsg 'Installing awesome fonts'
git clone https://github.com/gabrielelana/awesome-terminal-fonts ${HOME}/awesome-terminal-fonts
cd "${HOME}/awesome-terminal-fonts"; ./install.sh; cd "${HOME}"
rm -rf "${HOME}/awesome-terminal-fonts"

# Install oh-my-zsh
printmsg 'Installing oh-my-zsh'
printmsg 'Warning! Zsh prompt will be opened during installation, you need to close it with "exit" commmand. Press ENTER to continue'; read
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

# Move config back
printmsg 'Moving ~/.zshrc_backup back to ~/.zshrc'
mv --verbose --interactive "${HOME}/.zshrc_backup" "${HOME}/.zshrc"

# Powerlevel9k
printmsg 'Installing powerlevel9k theme'
git clone https://github.com/bhilburn/powerlevel9k.git ${HOME}/.oh-my-zsh/custom/themes/powerlevel9k

# Zsh syntax highlighting
printmsg 'Installing syntax highlighting'
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

printmsg 'Installation complete! Restart your terminal emulator'
exit 0
