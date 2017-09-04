# Colors
export TERM="xterm-256color"

PATH=${PATH}:$(find $HOME/bin -type d | tr '\n' ':' | sed 's/:$//')

# Path to your oh-my-zsh installation.
export ZSH="/home/$USER/.oh-my-zsh"

# Themes
ZSH_THEME="powerlevel9k/powerlevel9k"
POWERLEVEL9K_MODE='awesome-fontconfig'

# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
#HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
#DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
export UPDATE_ZSH_DAYS=10

# Uncomment the following line to disable colors in ls.
#DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
#DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
#COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
plugins=(archlinux git cloudapp perms autojump python history systemd web-search pass zsh-syntax-highlighting ) #colored-man-pages) #TODO

source $ZSH/oh-my-zsh.sh

# User configuration

# Reset keyboard settings
#setxkbmap -layout "us,ru"
#setxkbmap -option "grp:caps_toggle,grp_led:scroll,compose:ralt"

# My variables
export GITHUB='https://github.com/'
export HOME_SSH=''
export SSH_KEY_PATH="${HOME}/.ssh/dsa_id"
export LANG="en_US.UTF-8"
export EDITOR='vim'
export ZSHCONFIG="${HOME}/.zshrc"
export VIMCONFIG="${HOME}/.vimrc"
alias -s {txt,c,html,php,css}=vim
unsetopt correct_all
#export LANG="ru_RU.UTF-8"
#autoload -U pick-web-browser
#alias -s {html,htm}=chromium

# Powerlevel9k
# Main settings
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir dir_writable vcs disk_usage background_jobs root_indicator status)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=()
# Elements settings
POWERLEVEL9K_RAM_ELEMENTS=(ram_free)
POWERLEVEL9K_DISK_USAGE_WARNING_LEVEL=90
POWERLEVEL9K_DISK_USAGE_CRITICAL_LEVEL=95
# Custom icons
POWERLEVEL9K_LOCK_ICON=$'\UF023 '
POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=''
POWERLEVEL9K_MULTILINE_SECOND_PROMPT_PREFIX=" %F{green}╰─\UF0A9 %F{white}"
POWERLEVEL9K_DIR_HOME_BACKGROUND='green'
POWERLEVEL9K_DIR_HOME_SUBFOLDER_BACKGROUND='green'
POWERLEVEL9K_DIR_DEFAULT_BACKGROUND='green'
POWERLEVEL9K_RAM_BACKGROUND="black"
POWERLEVEL9K_RAM_FOREGROUND="yellow"

# History
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=50000
export SAVEHIST=${HISTSIZE}
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt APPEND_HISTORY

# Aliases
alias vi='vim'
alias myip='dig +short myip.opendns.com @resolver1.opendns.com'
alias whereami='curl ifconfig.co/json'
alias youtube-dl-mp3='youtube-dl --extract-audio --audio-format mp3'
alias vimwiki="vim ${HOME}/documents/vimwiki/index.wiki"
alias qr='reset'
alias c='xclip'
alias v='xclip -o'
alias ls='ls -h --color=tty --group-directories-first'
alias cc='cc -ansi' #TODO rm
alias cp='rsync -a --info=progress2'
alias packer='packer --noedit'
alias vcat='vcat.sh'
alias steam='ulimit -n 4096 && steam -silent'
alias steam-auth='mono "${HOME}/opt/steam-auth/Steam Desktop Authenticator.exe"'
alias yandex-sync='yandex-disk sync'
#alias calc='/usr/bin/env python3'
#alias cmus='reset-playlist.sh && cd /home/$USER/music/ && cmus'

# Functions

pk() {
if [ ${1} ]; then
	case $1 in
		tbz )
			tar cjvf "${2}.tar.bz2" "${2}"
			;;
		tgz )
			tar czvf "${2}.tar.gz"  "${2}"
			;;
		tar )
			tar cpvf "${2}.tar"  "${2}"
			;;
		bz2 )
			bzip "${2}"
			;;
		gz )
			gzip -c -9 -n ${2} > "${2}.gz"
			;;
		zip )
			zip -r "${2}.zip" "${2}"
			;;
		7z )
			7z a "${2}.7z" "${2}"
			;;
		* )
			echo "'$1' cannot be packed via pk()"
			;;
	esac
else
	echo "'${1}' is not a valid file"
fi
}

archlinux-update() {
	packer -Syu

	sudo mkinitcpio -p linux
	sudo vmware-modconfig --console --install-all
	sudo bootctl --path=/boot update

	sudo locale-gen
	sudo fc-cache -f -v

	sudo pacman -Scc
	echo -e "\nDon't forget to run reset-env.sh and backup.sh"
}

my_logs() {
	sudo systemctl --failed
	sudo journalctl -p 3 -xb
}

mem() {
	ps -eo rss,pid,euser,args:100 --sort %mem | \
		grep -v grep | grep -i $@ | \
		awk '{printf $1/1024 "MB"; $1=""; print }'
}

chperm() {
	chown -R ${USER}:${USER} ${1}
	find ${1} -type d -exec chmod 755 {} +
	find ${1} -type f -exec chmod 644 {} +
	find ${1} -type f -name \*.sh -exec chmod 744 {} +
	find ${1} -type f -name \*.out -exec chmod 744 {} +
	find ${1} -type f -name \*.run -exec chmod 744 {} +
}
