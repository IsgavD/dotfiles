# load shared shell configuration
source ~/.shprofile

# Enable completions
autoload -U compinit && compinit -C

if which brew &>/dev/null
then
  [ -w "$HOMEBREW_PREFIX/bin/brew" ] && \
    [ ! -f "$HOMEBREW_PREFIX/share/zsh/site-functions/_brew" ] && \
    mkdir -p "$HOMEBREW_PREFIX/share/zsh/site-functions" &>/dev/null && \
    ln -s "$HOMEBREW_PREFIX/Library/Contributions/brew_zsh_completion.zsh" \
          "$HOMEBREW_PREFIX/share/zsh/site-functions/_brew"
  export FPATH="$HOMEBREW_PREFIX/share/zsh/site-functions:$FPATH"
fi

# Enable regex moving
autoload -U zmv

# Style ZSH output
zstyle ':completion:*:descriptions' format '%U%B%F{red}%d%f%b%u'
zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'

# Case insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Case insensitive globbing
setopt no_case_glob

# Expand parameters, commands and aritmatic in prompts
setopt prompt_subst

# Colorful prompt with Git and Subversion branch
autoload -U colors && colors

git_branch() {
  GIT_BRANCH=$(git symbolic-ref --short HEAD 2>/dev/null) || return
  [ -n "$GIT_BRANCH" ] && echo "($GIT_BRANCH) "
}

svn_branch() {
  [ -d .svn ] || return
  SVN_INFO=$(svn info 2>/dev/null) || return
  SVN_BRANCH=$(echo "$SVN_INFO" | grep URL: | grep -oe '\(trunk\|branches/[^/]\+\|tags/[^/]\+\)')
  [ -n "$SVN_BRANCH" ] || return
  # Display tags intentionally so we don't write to them by mistake
  echo "(${SVN_BRANCH#branches/}) "
}

if [ "$USER" = "root" ]
then
  export PROMPT='%{$fg_bold[magenta]%}%m %{$fg_bold[blue]%}# %b%f'
elif [ -n "${SSH_CONNECTION}" ]
then
  export PROMPT='%{$fg_bold[cyan]%}%m %{$fg_bold[blue]%}# %b%f'
else
  export PROMPT='%{$fg_bold[green]%}%m %{$fg_bold[blue]%}# %b%f'
fi
export RPROMPT='%{$fg_bold[red]%}$(git_branch)%{$fg_bold[yellow]%}$(svn_branch)%b[%{$fg_bold[blue]%}%~%b%f]'

# more macOS/Bash-like word jumps
export WORDCHARS=""

# Created by `pipx` on 2022-02-06 11:31:40
export PATH="$PATH:/Users/isgav/.local/bin"

# Intel-era python.org framework installs removed from PATH during Apple Silicon
# migration (2026-05-14). These were x86_64 binaries left over from the old Mac.
# Python is managed via pyenv now.
# PATH="/Library/Frameworks/Python.framework/Versions/3.10/bin:${PATH}"
# PATH="/Library/Frameworks/Python.framework/Versions/3.9/bin:${PATH}"
# PATH="/Library/Frameworks/Python.framework/Versions/3.11/bin:${PATH}"

eval "$(/opt/homebrew/bin/brew shellenv zsh)"
