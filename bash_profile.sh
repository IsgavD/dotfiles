# load shared shell configuration
source ~/.shprofile

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# check if this is a login and/or interactive shell
[ "$0" = "-bash" ] && export LOGIN_BASH=1
echo "$-" | grep -q "i" && export INTERACTIVE_BASH=1

# run bashrc if this is a login, interactive shell
if [ -n "$LOGIN_BASH" ] && [ -n "$INTERACTIVE_BASH" ]
then
  source ~/.bashrc
fi

# Set HOST for ZSH compatibility
export HOST="$HOSTNAME"

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Enable history appending instead of overwriting.
shopt -s histappend

# Save multiline commands
shopt -s cmdhist

# Correct minor directory changing spelling mistakes
shopt -s cdspell

# Bash completion
[ -f /etc/profile.d/bash-completion ] && source /etc/profile.d/bash-completion
[ -f "$HOMEBREW_PREFIX/etc/bash_completion" ] && source "$HOMEBREW_PREFIX/etc/bash_completion" >/dev/null

# Colorful prompt
if [ "$USER" = "root" ]
then
  PS1='\[\033[01;35m\]\h\[\033[01;34m\] \W #\[\033[00m\] '
elif [ -n "${SSH_CONNECTION}" ]
then
  PS1='\[\033[01;36m\]\h\[\033[01;34m\] \W #\[\033[00m\] '
else
  PS1='\[\033[01;32m\]\h\[\033[01;34m\] \W #\[\033[00m\] '
fi

# only set key bindings on interactive shell
if [ -n "$INTERACTIVE_BASH" ]
then
  # fix delete key on macOS
  [ "$MACOS" ] && bind '"\e[3~" delete-char'

  # alternate mappings for Ctrl-U/V to search the history
  bind '"^u" history-search-backward'
  bind '"^v" history-search-forward'
fi

# Init jenv
if which jenv > /dev/null; then eval "$(jenv init -)"; fi

# Init pyenv
eval "$(pyenv init -)"

# Init pyenv-virtualenv
eval "$(pyenv virtualenv-init -)"

# Pipenv shell completions
eval "$(pipenv --completion)"

# Init nodenv
eval "$(nodenv init -)"

export PATH="/usr/local/opt/gettext/bin:$PATH"
export PATH="/usr/local/opt/node@10/bin:$PATH"

export LDFLAGS="-L/usr/local/opt/openssl/lib"
export CPPFLAGS="-I/usr/local/opt/openssl/include"

export CLOUDSDK_PYTHON=python3

source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.bash.inc'
source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc'

