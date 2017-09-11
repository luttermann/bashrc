# Enable bash_completion
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

# Setup rvm
if [ -f ~/.rvm/scripts/rvm ]; then
  source ~/.rvm/scripts/rvm
fi

# Use the trash can
if command /usr/local/bin/trash &>/dev/null; then
  alias rm=/usr/local/bin/trash
fi

# Use gpg-agent for ssh
test -f ~/.gpg-agent-info && . ~/.gpg-agent-info

# Colorize commands
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

# Make gettext availiable from brew
export PATH="/usr/local/opt/gettext/bin:$PATH"

# Add ~/local/*/bin to PATH
export PATH=$(printf "%s:" ~/local/*/bin):$PATH

# Allow changing into some dirs directly
CDPATH=.:~/Projects

# Load local bash-completions
for bc in ~/local/bash_completion/bash_completion.d/*; do
  source "$bc"
done

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

# Setup bash history
HISTCONTROL=ignoreboth
HISTSIZE=-1
HISTTIMEFORMAT='%F %T: '
shopt -s histappend
shopt -s cmdhist

# Enable extended globs
shopt -s extglob

# Prompt
function __prompt_cmd
{
  local EXIT=$?
  local blue="\[\e[34m\]"
  local red="\[\e[31m\]"
  local green="\[\e[32m\]"
  local normal="\[\e[m\]"
  PS1=""

  # exit status
  if [ $EXIT != 0 ]; then
    PS1+=$red
  else
    PS1+=$blue
  fi
  PS1+="⟩"

  # directory
  PS1+="$blue\W$normal"

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
    PS1+="${green}*${normal}"
  fi

  # Python virtualenv
  if [ -n "$VIRTUAL_ENV" ]; then
    PS1+="[${VIRTUAL_ENV##*/}]"
  fi

  # Arrow
  PS1+=" λ "

  # Save history continuously
  history -a
}
PROMPT_COMMAND=__prompt_cmd
# Don't have python virtual environment set prompt
export VIRTUAL_ENV_DISABLE_PROMPT=1
