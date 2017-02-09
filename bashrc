set completion-ignore-case on
# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# append to history (it should work for multiple terminals)
shopt -s histappend
# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups
# ... and ignore same sucessive entries.
export HISTCONTROL=ignoreboth
export HISTSIZE=10000

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
#export PS1='${BLUE}\t${D} ${PINK}\u ${D}at ${ORANGE}\h ${D}in ${GREEN}\w${D}\n$ '
export PS1='${BLUE}\t${D} ${PINK}\u ${D}in ${GREEN}\w${D}\n$ '

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
alias ll='ls -lh'
alias la='ls -A'
alias l='ls -CF'
# ld is taken (see $man ld)
alias lsd='ls -d */'

alias md='mkdir'
alias rd='rmdir'

alias rm='rm -vf'
alias rm~="rm *~" # remove vim backup file
alias rmd='rm -vfR'

# make it human readable
alias df='df -h'
alias du='du -h'
alias du1='du -h --max-depth=1'

alias ..='cd ..'

# apt-get
alias apti='sudo apt-get install'
alias aptc='sudo apt-get clean'
alias aptp='sudo apt-get purge'
alias aptr='sudo apt-get remove'
alias apts='aptitude search'
alias aptu='sudo apt-get update'

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
alias copy="xclip -i -selection clipboard"

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
if [ -f ~/cd-history/bootstrap.sh ]; then
    source ~/cd-history/bootstrap.sh
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

highlight() { grep --color -E -- "$1|\$" "${@:2}"; }

countargs() {
    {
    for arg in "$@"
    do
        echo arg
    done
    } | wc -l
}

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    export PATH=$HOME/bin:$PATH
fi
if [ -d "$HOME/.local/bin" ] ; then
    export PATH=$HOME/.local/bin:$PATH
fi
if [ -d "$HOME/.cargo/bin" ] ; then
    export PATH=$HOME/.cargo/bin:$PATH
fi
