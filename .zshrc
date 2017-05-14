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
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
export UPDATE_ZSH_DAYS=10

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
plugins=(archlinux git cloudapp taskwarrior lol perms autojump python history systemd web-search pass zsh-syntax-highlighting) 

source $ZSH/oh-my-zsh.sh

# User configuration

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# export MANPATH="/usr/local/man:$MANPATH"

# My variables
export GITHUB='https://github.com/'
export HOME_SSH=''
export SSH_KEY_PATH="${HOME}/.ssh/dsa_id"
export LANG="en_US.UTF-8"
export EDITOR='vim'
alias -s {txt,c,html,php,css}=vim
unsetopt correct_all
# export LANG="ru_RU.UTF-8"
# autoload -U pick-web-browser
# alias -s {html,htm}=chromium

# Powerlevel9k
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir dir_writable vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status ram disk_usage root_indicator background_jobs)
POWERLEVEL9K_DISK_USAGE_WARNING_LEVEL=90
POWERLEVEL9K_DISK_USAGE_CRITICAL_LEVEL=95
# POWERLEVEL9K_CONTEXT_TEMPLATE="%n"

# History
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=123456
export SAVEHIST=${HISTSIZE}
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt APPEND_HISTORY

# Aliases
alias myip='dig +short myip.opendns.com @resolver1.opendns.com'
alias whereami='curl ifconfig.co/json'
alias youtube-dl-mp3='youtube-dl --extract-audio --audio-format mp3'
alias vimwiki="vim /home/$USER/documents/vimwiki/index.wiki" #TODO
alias qr='reset'
alias c='xclip'
alias v='xclip -o'
alias ls='ls -h --color=tty --group-directories-first'
alias cc='cc -ansi' #TODO rm
alias cp='rsync -a --info=progress2'
alias packer='packer --noedit'
# alias wine='/opt/wine-staging/bin/wine'
# alias winecfg='/opt/wine-staging/bin/winecfg'
# alias cmus='reset-playlist.sh && cd /home/$USER/music/ && cmus'

# Resize bug fix
# Set right side prompt to last current directory, using 3/8 the width
set_rps1() {
	(( cols = $COLUMNS * 3/8))
	RPS1="%${cols}<..<%~%<<"
}
set_rps1
# Reset right prompt, on window resize
TRAPWINCH () {
	set_rps1
}

# Man color
man() {
	env \
	LESS_TERMCAP_mb=$(printf "\e[1;31m") \
	LESS_TERMCAP_md=$(printf "\e[1;31m") \
	LESS_TERMCAP_me=$(printf "\e[0m") \
	LESS_TERMCAP_se=$(printf "\e[0m") \
	LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
	LESS_TERMCAP_ue=$(printf "\e[0m") \
	LESS_TERMCAP_us=$(printf "\e[1;32m") \
	man "$@"
}

# Pack
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

