# ========================================================
# Initialization zplug
# ========================================================
# Install zplug if you have not intalled yet.
if [[ ! -d $HOME/.zplug ]]; then
    curl -sL zplug.sh/installer | zsh
    source ~/.zplug/init.zsh && zplug update --self
fi

source ~/.zplug/init.zsh

# oh-my-zsh plugins
zplug "lib/theme-and-appearance", from:oh-my-zsh
zplug "plugins/zsh_reload", from:oh-my-zsh
zplug "plugins/colorize", from:oh-my-zsh
zplug "plugins/pip", from:oh-my-zsh, if:"[[ $(which pip) ]]"
zplug "plugins/repo", from:oh-my-zsh
zplug "themes/refined", from:oh-my-zsh

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
zplug "junegunn/fzf",  hook-build: "sh install --no-bash --no-fish --update-rc"
zplug "olivierverdier/zsh-git-prompt", use:"zshrc.sh"

# prezto
zplug "modules/git", from:prezto, if:"[[ $(which git) ]]"
zplug "modules/homebrew", from:prezto, if:"[[ $OSTYPE == *darwin* ]]"
zplug "modules/osx", from:prezto, if:"[[ $OSTYPE == *darwin* ]]"

#theme
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
export ZSH_THEME_GIT_PROMPT_CACHE=true
export GIT_PROMPT_EXECUTABLE="haskell"

### zsh-nvm ####
export NVM_LAZY_LOAD=true

### fzf ###
if zplug check junegunn/fzf; then
    [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
fi
export EDITOR='vim'
if [[ `command -v fd` ]]; then
    export FZF_DEFAULT_COMMAND='fd --type f'
fi
export FZF_DEFAULT_OPTS='--multi'
export NOTIFY_COMMAND_COMPLETE_TIMEOUT=300
export NVIM_TUI_ENABLE_CURSOR_SHAPE=1 # https://github.com/neovim/neovim/pull/2007#issuecomment-74863439
export FZF_COMPLETION_TRIGGER='**'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
# Then, source plugins and add commands to $PATH
zplug load
# ========================================================
# Customize environment variables
# ========================================================
# alias
alias jj=jobs

# Env Variables
if [[ -f $HOME/.zshenv ]];then
    source $HOME/.zshenv
fi
