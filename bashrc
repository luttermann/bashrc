export BASHRC_LOADED="TRUE"
export PATH="/usr/local/opt/gettext/bin:$PATH"

export LANG=en_US.UTF-8
export LANGUAGE=en
export LC_CTYPE=UTF-8
export LC_NUMERIC="en_US.UTF-8"
export LC_TIME="en_US.UTF-8"
export LC_COLLATE="en_US.UTF-8"
export LC_MONETARY="en_US.UTF-8"
export LC_MESSAGES="en_US.UTF-8"
export LC_PAPER="en_US.UTF-8"
export LC_NAME="en_US.UTF-8"
export LC_ADDRESS="en_US.UTF-8"
export LC_TELEPHONE="en_US.UTF-8"
export LC_MEASUREMENT="en_US.UTF-8"
export LC_IDENTIFICATION="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# Enable bash_completion
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

# Set commandline editor to vim
# C-x C-e
export VISUAL=vim

# Use the trash can
if command /usr/local/bin/trash &>/dev/null; then
  alias rm=/usr/local/bin/trash
fi

# Use gpg-agent for ssh
gpg-agent --daemon --enable-ssh-support > /dev/null 2> /dev/null
SSH_AUTH_SOCK=/Users/llp/.gnupg/S.gpg-agent.ssh
export SSH_AUTH_SOCK

# Colourise commands
if command grc &>/dev/null; then
  alias grc="grc -es --colour=auto"
  alias df='grc df'
  alias diff='grc diff'
  alias docker='grc docker'
  alias du='grc du'
  alias env='grc env'
  alias make='grc make'
  alias gcc='grc gcc'
  alias g++='grc g++'
  alias id='grc id'
  alias lsof='grc lsof'
  alias netstat='grc netstat'
  alias ping='grc ping'
  alias ping6='grc ping6'
  alias traceroute='grc traceroute'
  alias traceroute6='grc traceroute6'
  alias head='grc head'
  alias tail='grc tail'
  alias dig='grc dig'
  alias mount='grc mount'
  alias ps='grc ps'
  alias ifconfig='grc ifconfig'
fi
alias ls="ls -G"

# Put brew sbin into PATH
export PATH="/usr/local/sbin:$PATH"

# Make gettext availiable from brew
export PATH="/usr/local/opt/gettext/bin:$PATH"

# Add ~/local/*/bin to PATH
export PATH=$(printf "%s:" ~/local/*/bin):$PATH

# Allow changing into some dirs directly
CDPATH=.:~/Projects

# Load local bash-completions
if [ -d ~/local/bash_completion/bash_completion.d/ ]; then
  for bc in ~/local/bash_completion/bash_completion.d/*; do
    source "$bc"
  done
fi

# Case insensitive tab-completion
bind "set completion-ignore-case on"
bind "set show-all-if-ambiguous on"

# Show mathing parenthesis
bind "set blink-matching-paren on"

# Add some colour
bind "set colored-completion-prefix on"
bind "set colored-stats on"
bind "set visible-stats on"

# Don't wrap commandline
bind "set horizontal-scroll-mode on"

# Allow completion in the middle of words
bind "set skip-completed-text on"

# Search using command line up up and down arrow
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

# ctrl + arrow keys to move words
bind '"\e[1;2C":forward-word'
bind '"\e[1;2D":backward-word'

# vi mode
# set -o vi
# bind "set show-mode-in-prompt on"
# bind "set vi-ins-mode-string"
# bind "set vi-cmd-mode-string +"

# Setup bash history
HISTCONTROL=ignoreboth
HISTSIZE=-1
HISTTIMEFORMAT='%F %T: '
shopt -s histappend
shopt -s cmdhist

# Enable extended globs
shopt -s extglob

# List running background jobs before exiting
shopt -s checkjobs

# Show dot-files when tab completing
shopt -s dotglob

# expand ** and **/
shopt -s globstar

# Setup rvm
if [ -s ~/.rvm/scripts/rvm ]; then
  source ~/.rvm/scripts/rvm
  source ~/.rvm/scripts/completion
fi

# Prompt
function __prompt_cmd
{
  local exit_status=$?
  local blue="\\[\\e[34m\\]"
  local red="\\[\\e[31m\\]"
  local green="\\[\\e[32m\\]"
  local yellow="\\[\\e[33m\\]"
  local normal="\\[\\e[m\\]"
  PS1=""

  PS1+="[$yellow\D{%T}$normal] \\u@\\h$green \\w$normal"

  # git based on https://github.com/jimeh/git-aware-prompt/
  local branch
  if branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null); then
    if [ "$branch" = "HEAD" ]; then
      branch='detached*'
    fi
    PS1+=":${green}${branch}${normal}"
  fi

  local status=$(git status --porcelain 2> /dev/null)
  if [[ "$status" != "" ]]; then
    PS1+="${red}*${normal}"
  fi

  # Python virtualenv
  if [ -n "$VIRTUAL_ENV" ]; then
    PS1+="[${VIRTUAL_ENV##*/}]"
  fi

  # RVM
  if command rvm-prompt &> /dev/null; then
    if [ -n "$(rvm-prompt g)" ]; then
      PS1+="[$(rvm-prompt)]"
    fi
  fi

  PS1+="\\n"

  # exit status
  if [ $exit_status != 0 ]; then
    PS1+=$red
  else
    PS1+=$green
  fi
  PS1+="$exit_status"

  # Arrow
  PS1+=" => ${normal}"

  # Save history continuously
  history -a
}

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

PROMPT_COMMAND=__prompt_cmd
# Don't have python virtual environment set prompt
export VIRTUAL_ENV_DISABLE_PROMPT=1

if command fortune &> /dev/null; then
  printf '\033[0;35m'
  fortune -e -s
  printf '\033[0m'
fi

export LSCOLORS=gxCxfxfxcxDxDxacacagag

