# ========================================================
# Initialization zplug
# ========================================================
# Install zplug if you have not intalled yet.
if [[ ! -d $HOME/.zplug ]]; then
    curl -sL zplug.sh/installer | zsh
    source ~/.zplug/init.zsh && zplug update --self
fi

source ~/.zplug/init.zsh

# Install commands
zplug "Jxck/dotfiles", as:command, use:"bin/{histuniq,color}"
zplug "kenkuang1213/Kcmds", as:command, use:"bin/genCtags"
zplug "junegunn/fzf", as:command, use:"bin/{fzf,fzf-tmux}", hook-build:'./install --key-bindings --completion --no-update-rc'

# oh-my-zsh plugins
zplug "lib/theme-and-appearance", from:oh-my-zsh
zplug "lib/clipboard", from:oh-my-zsh, if:"[[ $OSTYPE == *darwin* ]]"
zplug "plugins/macports", from:oh-my-zsh, if:"[[ $OSTYPE == *darwin* ]]"
zplug "plugins/zsh_reload", from:oh-my-zsh
zplug "plugins/colorize", from:oh-my-zsh
zplug "plugins/pip", from:oh-my-zsh
zplug "plugins/repo", from:oh-my-zsh
zplug "olivierverdier/zsh-git-prompt", use:"zshrc.sh", hook-build:"curl -sSL https://get.haskellstack.org/ | sh;stack setup;stack build && stack install"

#other zsh plugin
zplug "zsh-users/zsh-completions",  defer:2
zplug "zsh-users/zsh-autosuggestions",  defer:2
zplug "felixr/docker-zsh-completion"
zplug "zsh-users/zsh-history-substring-search", defer:3
zplug "zsh-users/zsh-syntax-highlighting", defer:3
zplug "Tarrasch/zsh-autoenv"
zplug "zplug/zplug"
zplug "chrissicool/zsh-256color"
zplug "tcnksm/docker-alias", use:zshrc
zplug "lukechilds/zsh-nvm"

# prezto
zplug "modules/git", from:prezto
zplug "modules/homebrew", from:prezto, if:"[[ $OSTYPE == *darwin* ]]"
zplug "modules/node", from:prezto
zplug "modules/osx", from:prezto, if:"[[ $OSTYPE == *darwin* ]]"

#theme
zplug "kenkuang1213/81a9dd6aeab6241210fdfd0363c6861a", from:gist, as:theme
#####################################################################
# completions
#####################################################################

# Enable completions
if [ -d ~/.zsh/comp ]; then
    fpath=(~/.zsh/comp $fpath)
    autoload -U ~/.zsh/comp/*(:t)
fi

zstyle ':completion:*' group-name ''
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:descriptions' format '%d'
zstyle ':completion:*:options' verbose yes
zstyle ':completion:*:values' verbose yes
zstyle ':completion:*:options' prefix-needed yes
# Use cache completion
# apt-get, dpkg (Debian), rpm (Redhat), urpmi (Mandrake), perl -M,
# bogofilter (zsh 4.2.1 >=), fink, mac_apps...
zstyle ':completion:*' use-cache true
zstyle ':completion:*:default' menu select=1
zstyle ':completion:*' matcher-list \
    '' \
    'm:{a-z}={A-Z}' \
    'l:|=* r:|[.,_-]=* r:|=* m:{a-z}={A-Z}'
# sudo completions
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
    /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin
zstyle ':completion:*' menu select
zstyle ':completion:*' keep-prefix
zstyle ':completion:*' completer _oldlist _complete _match _ignored \
    _approximate _list _history

autoload -U compinit
if [ ! -f ~/.zcompdump -o ~/.zshrc -nt ~/.zcompdump ]; then
    compinit -d ~/.zcompdump
fi

# Original complete functions
compdef '_files -g "*.hs"' runhaskell
compdef _man w3mman
compdef _tex platex

# cd search path
cdpath=($HOME)

zstyle ':completion:*:processes' command "ps -u $USER -o pid,stat,%cpu,%mem,cputime,command"

# auto-fu.zsh
# function zle-line-init () {
#     auto-fu-init
# }
# zle -N zle-line-init
# zstyle ':completion:*' completer _oldlist _complete


# Run a command after a plugin is installed/updated
zplug "tj/n", as:command, use:'bin/n', hook-build:"make install"

# Supports checking out a specific branch/tag/commit
zplug "b4b4r07/enhancd", at:v1
zplug "mollifier/anyframe", at:4c23cb60

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# ========================================================
# Set ZSH opt
# ========================================================
setopt autopushd
# ZSH history
setopt append_history
setopt hist_expire_dups_first
setopt hist_fcntl_lock
setopt hist_ignore_all_dups
setopt hist_lex_words
setopt hist_reduce_blanks
setopt hist_save_no_dups
setopt share_history

export CLICOLOR=1
export BLOCK_SIZE=human-readable # https://www.gnu.org/software/coreutils/manual/html_node/Block-size.html
export HISTSIZE=11000
export SAVEHIST=10000
export HISTFILE=~/.zsh_history

export DISABLE_AUTO_TITLE=true
export DISABLE_CORRECTION=true
export DISABLE_UNTRACKED_FILES_DIRTY=true # Improves repo status check time.
export DISABLE_UPDATE_PROMPT=true

export UPDATE_ZSH_DAYS=1
### fzf ###
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export EDITOR='vim'
if [[ `command -v ag` ]]; then
    export FZF_DEFAULT_COMMAND='ag -g ""'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi
export FZF_DEFAULT_OPTS='--multi'
export NOTIFY_COMMAND_COMPLETE_TIMEOUT=300
export NVIM_TUI_ENABLE_CURSOR_SHAPE=1 # https://github.com/neovim/neovim/pull/2007#issuecomment-74863439
export FZF_COMPLETION_TRIGGER='**'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

### AUTOSUGGESTIONS ###
if zplug check zsh-users/zsh-autosuggestions; then
    ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(history-substring-search-up history-substring-search-down) # Add history-substring-search-* widgets to list of widgets that clear the autosuggestion
    ZSH_AUTOSUGGEST_CLEAR_WIDGETS=("${(@)ZSH_AUTOSUGGEST_CLEAR_WIDGETS:#(up|down)-line-or-history}") # Remove *-line-or-history widgets from list of widgets that clear the autosuggestion to avoid conflict with history-substring-search-* widgets
fi

### KEY BINDINGS ###
KEYTIMEOUT=1 # Prevents key timeout lag.
bindkey -v

# Bind UP and DOWN arrow keys for subsstring search.
if zplug check zsh-users/zsh-history-substring-search; then
    zmodload zsh/terminfo
    bindkey "$terminfo[kcuu1]" history-substring-search-up
    bindkey "$terminfo[kcud1]" history-substring-search-down
fi

# ZSH Hightlight
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor) 

# Then, source plugins and add commands to $PATH
zplug load --verbose

### Porting olivierverdier/zsh-git-prompt to oh-my-zsh git ###
function git_prompt_info(){
    precmd_update_git_vars
    echo "%{$fg[green]%}$GIT_BRANCH%{${reset_color}%}"
}
function git_prompt_status(){
    if [ -n "$__CURRENT_GIT_STATUS" ]; then
        if [ "$GIT_BEHIND" -ne "0" ]; then
            STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_BEHIND$GIT_BEHIND%{${reset_color}%}"
        fi
        if [ "$GIT_AHEAD" -ne "0" ]; then
            STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_AHEAD$GIT_AHEAD%{${reset_color}%}"
        fi
        STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_SEPARATOR"
        if [ "$GIT_STAGED" -ne "0" ]; then
            STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_STAGED$GIT_STAGED%{${reset_color}%}"
        fi
        if [ "$GIT_CONFLICTS" -ne "0" ]; then
            STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_CONFLICTS$GIT_CONFLICTS%{${reset_color}%}"
        fi
        if [ "$GIT_CHANGED" -ne "0" ]; then
            STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_CHANGED$GIT_CHANGED%{${reset_color}%}"
        fi
        if [ "$GIT_UNTRACKED" -ne "0" ]; then
            STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_UNTRACKED%{${reset_color}%}"
        fi
        if [ "$GIT_CHANGED" -eq "0" ] && [ "$GIT_CONFLICTS" -eq "0" ] && [ "$GIT_STAGED" -eq "0" ] && [ "$GIT_UNTRACKED" -eq "0" ]; then
            STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_CLEAN"
        fi
        echo "$STATUS"
    fi
}
export ZSH_THEME_GIT_PROMPT_CACHE=1
export ZPLUG_USE_CACHE=0
export GIT_PROMPT_EXECUTABLE="haskell"
# ========================================================
# Customize environment variables
# ========================================================
# alias
alias jj=jobs

# Env Variables
if [[ -d $HOME/.zshenv ]];then
    source $HONE/.zshenv
fi
