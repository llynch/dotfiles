set completion-ignore-case on
# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# append to history (it should work for multiple terminals)
shopt -s histappend

# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups
# ... and ignore same sucessive entries.
export HISTCONTROL=ignoreboth
export HISTFILESIZE=1000000000
export HISTSIZE=1000000
export HISTTIMEFORMAT="%Y-%m-%d %H:%T "

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

D=$'\e[37;00m'
PINK=$'\e[35;40m'
GREEN=$'\e[32;40m'
ORANGE=$'\e[33;40m'
RED=$'\e[31;40m'
BLUE=$'\e[34;40m'
YELLOW=$'\e[36;40m'
#export PS1='${BLUE}\t${D} ${PINK}\u ${D}at ${ORANGE}\h ${D}in ${GREEN}\w${D}\n$ '

parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
parse_virtual_env() {
    venv=$(basename "$VIRTUAL_ENV")
    test "$VIRTUAL_ENV" > /dev/null && printf "$venv "
}
parse_kubectl_project() {
    kubectl_project=`grep project /home/llynch/.config/gcloud/configurations/config_default | sed 's/project = //g'`
    #kubectl_project=`gcloud config get-value project`
    test "$kubectl_project" > /dev/null && printf "$kubectl_project "
}
export VIRTUAL_ENV_DISABLE_PROMPT=1
export PS1='${BLUE}\t${D} ${PINK}\u ${D}${ORANGE}$(parse_virtual_env)${D}in ${GREEN}\w${D}${YELLOW}$(parse_git_branch)${D}\n$ '

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
    ;;
*)
    ;;
esac

#function _update_ps1() {
#    PS1="$(~/powerline-shell/powerline-shell.py $? 2> /dev/null)"
#}

#if [ "$TERM" != "linux" ]; then
#    PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
#fi

# Disable the damm internal speaker
# amixer set 'PC Beep' 0% mute > /dev/null
#setterm -blength 0
#xset b off

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

#if [ -f ~/.bash_aliases ]; then
#    . ~/.bash_aliases
#fi

# enable color support of ls and also add handy aliases
if [ "$TERM" != "dumb" ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
    alias dir='ls --color=auto --format=vertical'
    alias vdir='ls --color=auto --format=long'

    alias grep='grep --color=auto'
    alias egrep='egrep --color=auto'
    alias fgrep='fgrep --color=auto'
fi

# some more ls aliases
alias ls='eza --icons'
alias ll='eza -lh --icons'
alias la='eza -A --icons'
alias l='eza -F --icons'
alias fd='fdfind'

#alias ls="\lsd"
alias di='docker inspect'
alias did='docker ps --format "table {{.ID}}\t{{.Image}}\t{{.Names}}" | sed 1d | fzf -m | awk "{print \$1}"'

#alias ll='ls -lh'
#alias la='ls -A'
#alias l='ls -CF'

alias md='mkdir'
alias rd='rmdir'

alias rm='rm -f'
alias rm~="rm *~" # remove vim backup file
alias rmd='rm -fR'

# make it human readable
alias df='df -h'
alias du='du -h'
alias du1='du -h --max-depth=1'

alias ..='cd ..'

# apt-get
alias apti='sudo apt install -y'
alias aptc='sudo apt clean'
alias aptp='sudo apt purge'
alias aptr='sudo apt remove'
alias apts='sudo apt search'
alias aptu='sudo apt update -y'

# pacman
alias paci='sudo pacman -S'
alias pacs='sudo pacman -Ss'

# locate
alias udb='sudo updatedb'

# mouting
alias mntiso='sudo mount -o loop'
alias mnt='sudo mount'

alias tmux="tmux -2"

# usin xclip to copy to clipboard
alias xclip='xclip -selection clipboard'

alias g="git"
alias navi="navi --print"
alias cat="bat -p"

alias venv="source .venv/bin/activate"

# http://www.commandlinefu.com/commands/browse/sort-by-votes/
# quick calculator
? () { echo "$*" | bc -l; }

# define words using google
define(){ local y="$@";curl -sA"Opera" "http://www.google.com/search?q=define:${y// /+}"|grep -Po '(?<=<li>)[^<]+'|nl|perl -MHTML::Entities -pe 'decode_entities($_)' 2>/dev/null | iconv -tutf-8 -fiso-8859-1;}
define_raw(){
    local y="$@"; hxnormalize -l 240 -x <(curl -s "http://www.thefreedictionary.com/${y// /+}") | hxselect -s '\n' -c "div#MainTxt" | html2text
}
define(){ define_raw $@ | vim -; }

# translate from google
translate(){ wget -qO- "http://ajax.googleapis.com/ajax/services/language/translate?v=1.0&q=$1&langpair=$2|${3:-en}" | sed 's/.*"translatedText":"\([^"]*\)".*}/\1\n/'; }

# UTIL
#
if [ -f ~/github/llynch/cd-history/bootstrap.sh ]; then
    source ~/github/llynch/cd-history/bootstrap.sh
fi
#alias c=cdd
#
util() { sed -n '/# util/,/# ''END UTIL/p' ~/.bashrc; }
csv() { xargs -0I'{}' echo '{}' |  sed 's/\s*\(\w\w*\)\s\s*/\1;/g'; }
uncsv() { xargs -0I'{}' echo '{}' |  sed 's/;/\t/g'; }
deletefirstline() { xargs -0I'{}' echo '{}' | sed '1d'; }
noemptylines() { xargs -0I'{}' echo '{}' | sed '/^\s*$/d'; } 
selectcolumn() { xargs -0I'{}' echo '{}' | cut -d';' -f"$*" ; }
singleline() { sed -n '1,$ s/.*/\"&\"/g ; 1,$ H; $x; $s/\n/ /g; $p'; }
vx () { [ -e "$*" ] && echo "file \'$*\' already exists" && return ; echo -e "#!/bin/bash\n" >> "$*"; chmod +x "$*"; vim -c "e $*" -c "2" ; }
echoif() { echo "if [ $* ]"; if [ $* ]; then echo true; else echo false; fi; }
#man () { whatis "$*" && /usr/bin/man -Tutf8 "$*" | col -b | vim -c 'set ft=man' -c 'nmap q :q!<CR>' -; }
info() { tmp=`mktemp`; /usr/bin/info "$*" > $tmp 2> /dev/null ; vim -c 'set ft=man' -c 'nmap q :q!<CR>' $tmp; /bin/rm -rf $tmp; }
mank() { /usr/bin/man -k "$*"; }
cleanjs() { sed 's_\\t__g;s_,\\n\s*}_}_g;s_"{_{_g;s_\\n_\n_g;s_\\"_"_g;/^"$/d' /dev/stdin; }
# END UTIL

# Got from:
# http://www.tuxhelper.info/
function extract()
{
  if [ -f "$1" ] ; then
    case "$1" in
      *.tar.bz2) tar xvjf "$1" ;;
      *.tar.gz) tar xvzf "$1" ;;
      *.tar.Z) tar xvzf "$1" ;;
      *.bz2) bunzip2 "$1" ;;
      *.rar) unrar x "$1" ;;
      *.gz) gunzip "$1" ;;
      *.jar) unzip "$1" ;;
      *.tar) tar xvf "$1" ;;
      *.tbz2) tar xvjf "$1" ;;
      *.tgz) tar xvzf "$1" ;;
      *.zip) unzip "$1" ;;
      *.Z) uncompress "$1" ;;
      *) echo "'$1' cannot be extracted." ;;
    esac
  else
    echo "'$1' is not a file."
  fi
}

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

#if [ -f ~/.splash ]; then
#    cat ~/.splash
#fi

#PATH=$PATH:/home/lynch/.buildozer/android/platform/android-sdk-20/tools/
#PATH=$PATH:/home/lynch/.buildozer/android/platform/android-sdk-20/platform-tools/
v() { 
    vim -c ScratchBuffer -;
}

hl() { grep --color -E -- "$1|\$" "${@:2}"; }

countargs() {
    {
    for arg in "$@"
    do
        echo arg
    done
    } | wc -l
}

hdmi2() {
    echo 'xrandr --output HDMI-2 --auto --left-of eDP-1 --output eDP-1'
    xrandr --output HDMI-2 --auto --left-of eDP-1 --output eDP-1
}

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    export PATH=$HOME/bin:$PATH
fi
if [ -d "$HOME/opt/gradle-4.4.1/bin" ] ; then
    export PATH="$HOME/opt/gradle-4.4.1/bin":$PATH
fi
if [ -d "$HOME/.local/bin" ] ; then
    export PATH=$HOME/.local/bin:$PATH
fi
if [ -d "$HOME/.cargo/bin" ] ; then
    export PATH=$HOME/.cargo/bin:$PATH
fi
if [ -d "$HOME/.cargo/env" ] ; then
    . "$HOME/.cargo/env"
fi

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
source ~/github/llynch/cd-history/bootstrap.sh

# vex auto complete
complete -W "`vex --list`" vex

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
# export CLOUDSDK_PYTHON=/usr/bin/python2

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


export DUCTTAPE_DIR=~/github/llynch/ducttape/

#source ~/.bashrc.d/docker
source $DUCTTAPE_DIR/aliases.sh
source ~/.bashrc.d/cheat
source ~/.bashrc.d/fzf
#source ~/.bashrc.d/fzf-bash-completion.sh
#source ~/.bashrc.d/kubectl
source ~/.bashrc.d/lscolors.sh
source ~/.bashrc.d/man
source ~/.bashrc.d/nix.sh
source ~/.bashrc.d/nvim
#source ~/.bashrc.d/feltboard/variables
#source ~/.bashrc.d/feltboard/main
#source ~/.bashrc.d/powerline
#oh-my-posh init bash --config ~/.config/ho-my-posh/themes/emodipt-extend.omp.json > ~/.ho-my-posh

# Ghsotty
# running ghostty on ubuntu 24.04.1 LTS with ibus version 1.5.29 and gtk version 4.14.2 fixes the accent issue for me.
#found this tip here: https://bugs.launchpad.net/ubuntu/+source/ibus/+bug/2064025
export GTK_IM_MODULE=simple


#source ~/.ho-my-posh
colored_kubectl_project() {
    printf "${RED}$(parse_kubectl_project)${D}"
}
#PROMPT_COMMAND="_omp_hook; "

# command to set a tab title
settitle() { printf "\e]2;${1:-$(basename ${PWD})}\a"; }
st() { settitle; }
stt() { settitle; }
settitle

# https://www.pgrs.net/2022/06/02/simple-command-line-function-to-decode-jwts/
codejwt-decode() { jq -R 'split(".") |.[0:2] | map(@base64d) | map(fromjson)' <<< $1; }

#neofetch --jp2a ~/Pictures/feltboard.jpg --size 22%
#jp2a ~/Pictures/feltboard.jpg --size=40x22 --colors
#neofetch --colors 2 12 2 2 2 12 --jp2a ~/Pictures/feltboard.jpg --size 22%
#cat ~/.prompt

#source ~/.ho-my-posh

# curl -sS https://starship.rs/install.sh | sh
eval "$(starship init bash)"
source ~/.bash.tmux-bash-completion

# opencode
export PATH=/home/lynch/.opencode/bin:$PATH
export EDITOR=nvim
