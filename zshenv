# Locale
if [[ "$OSTYPE" == darwin* ]]; then
    export LANG="en_US.UTF-8"
    export LC_CTYPE="en_US.UTF-8"
fi

# Use 256 color terminal inside tmux
if [[ -n "$TMUX" ]]; then
   export TERM="screen-256color"
fi

# Set PATH
function path-prepend {
    [[ -d "$1" ]] && path[1,0]=($1)
}
path-prepend "/usr/local/sbin"
path-prepend "/usr/local/bin"
path-prepend "/usr/local/go/bin"
path-prepend "$HOME/.local/bin"

# Set CDPATH
function cdpath-append {
    [[ -d "$1" ]] && cdpath+=($1)
}
cdpath-append "$HOME"
cdpath-append "$HOME/p"

# Ensure path and cdpath do not contain duplicates
typeset -gU path cdpath

# Set EDITOR to emacs or vim
if (( $+commands[emacsclient] )); then
    export EDITOR="emacsclient -q"
elif (( $+commands[emacs] )); then
    export EDITOR="emacs"
elif (( $+commands[mg] )); then
    export EDITOR="mg"
elif (( $+commands[vim] )); then
    export EDITOR="vim"
fi

# Set LS_COLORS
if (( $+commands[gdircolors] )); then
    eval "$(gdircolors -b)"
elif (( $+commands[dircolors] )); then
    eval "$(dircolors -b)"
fi

# Remove mosh prefix from terminal title
(( $+commands[mosh] )) && export MOSH_TITLE_NOPREFIX=1

# GOPATH
if [[ -d "${HOME}/go" ]]; then
    export GOPATH="${HOME}/go"
    path-prepend "${GOPATH}/bin"
    cdpath-append "${GOPATH}/src/github.com/martinp"
fi

# Local environment
[[ -s "$HOME/.zshenv.local" ]] && source "$HOME/.zshenv.local"

# Clean up functions
unfunction path-prepend
unfunction cdpath-append