# check if this is a login shell
[ "$0" = "-zsh" ] && export LOGIN_ZSH=1

# run zprofile if this is not a login shell
[ -n "$LOGIN_ZSH" ] && source ~/.zprofile

# load shared shell configuration
# rbenv-sync-homebrew-rubies starts a Ruby interpreter (~450ms) even when rbenv
# is not installed. Shadow it with a no-op to avoid the cost.
command -v rbenv >/dev/null 2>&1 || rbenv-sync-homebrew-rubies() { :; }
source ~/.shrc

# History file
export HISTFILE=~/.zsh_history

# Don't show duplicate history entires
setopt hist_find_no_dups

# Remove unnecessary blanks from history
setopt hist_reduce_blanks

# Share history between instances
setopt share_history

# Don't hang up background jobs
setopt no_hup

# use emacs bindings even with vim as EDITOR
bindkey -e

# fix backspace on Debian
[ -n "$LINUX" ] && bindkey "^?" backward-delete-char

# fix delete key on macOS
[ -n "$MACOS" ] && bindkey '\e[3~' delete-char

# alternate mappings for Ctrl-U/V to search the history
bindkey "^u" history-beginning-search-backward
bindkey "^v" history-beginning-search-forward

# Created by `pipx` on 2022-02-06 11:31:40
export PATH="$PATH:/Users/isgav/.local/bin"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/isgav/Work/repos/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/isgav/Work/repos/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/isgav/Work/repos/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/isgav/Work/repos/google-cloud-sdk/completion.zsh.inc'; fi

# Shadow slow brew --prefix calls before .ai21_zshrc loads.
# (Previous pyenv/nodenv no-op shadows + lazy-loaders caused infinite recursion
# on python3/pyenv calls after the Time Machine migration — _load_pyenv was not
# reachable. Switched to eager init below — adds ~50ms but kills the bug class.
# — 2026-05-14)
brew() {
    [[ "$1 $2" == "--prefix openblas" ]]    && { echo "/usr/local/opt/openblas"; return; }
    [[ "$1 $2" == "--prefix openssl@1.1" ]] && { echo "/usr/local/opt/openssl@1.1"; return; }
    command brew "$@"
}

source ~/.ai21_zshrc

# Restore real brew.
unset -f brew

# Eager init for pyenv/nodenv (was lazy — see comment above).
if command -v pyenv &>/dev/null; then
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"
    command -v pyenv-virtualenv-init &>/dev/null && eval "$(pyenv virtualenv-init -)"
fi
if command -v nodenv &>/dev/null; then
    eval "$(nodenv init -)"
fi
export GOOGLE_CLOUD_PROJECT="algo-studio-main"
# Intel-era node@20 path removed during Apple Silicon migration (2026-05-14).
# NVM lazy-loader below handles node/npm/npx.
# export PATH="/usr/local/opt/node@20/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
# Lazy-load NVM: only load when nvm/node/npm/npx is first called
if [ -s "$NVM_DIR/nvm.sh" ]; then
  _load_nvm() {
    unset -f nvm node npm npx yarn
    \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
  }
  nvm()  { _load_nvm; nvm  "$@"; }
  node() { _load_nvm; node "$@"; }
  npm()  { _load_nvm; npm  "$@"; }
  npx()  { _load_nvm; npx  "$@"; }
fi

# Turso
export PATH="$PATH:/Users/isgav/.turso"
eval "$(/opt/homebrew/bin/brew shellenv)"
