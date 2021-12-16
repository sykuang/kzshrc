#!/bin/zsh

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing DHARMA Initiative Plugin Manager (zdharma/zinit)…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
# if ((!$+commands[starship])) ;then
# curl -fsSL https://starship.rs/install.sh | bash
# fi
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zinit-zsh/z-a-patch-dl \
    zinit-zsh/z-a-as-monitor \
    zinit-zsh/z-a-bin-gem-node

### End of Zinit's installer chunk

# Theme
# zinit ice pick"async.zsh" src"pure.zsh"
# zinit light sindresorhus/pure
# eval "$(starship init zsh)"
zinit ice depth=1; zinit light romkatv/powerlevel10k
# Autoenv
zinit ice depth=1;zinit ice lucid wait src"autoenv.zsh"
zinit light Tarrasch/zsh-autoenv

# completions
zinit wait="0" lucid atload"zicompinit; zicdreplay" blockf for \
    zsh-users/zsh-completions

# syntax highlight
zinit wait lucid for \
 atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
    zdharma-continuum/fast-syntax-highlighting \
 blockf \
    zsh-users/zsh-completions \
 atload"!_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions

# Auto sugggestions
zinit ice lucid wait="0" atload='_zsh_autosuggest_start'
zinit light zsh-users/zsh-autosuggestions

# zsh color
zinit light chrissicool/zsh-256color

# git diff so fancy
zinit ice wait="2" lucid as"program" pick"bin/git-dsf"
zinit light zdharma/zsh-diff-so-fancy

# Extending Git
zinit as"null" wait"1" lucid for \
    sbin    Fakerr/git-recall \
    sbin    cloneopts paulirish/git-open \
    sbin    paulirish/git-recent \
    sbin    davidosomething/git-my \
    sbin atload"export _MENU_THEME=legacy" \
            arzzen/git-quick-stats \
    sbin    iwata/git-now \
    make"PREFIX=$ZPFX install" \
            tj/git-extras \
    sbin"git-url;git-guclone" make"GITURL_NO_CGITURL=1" \
            zdharma-continuum/git-url

# OMZ framework
zinit snippet OMZ::lib/key-bindings.zsh
zinit snippet OMZ::lib/completion.zsh
zinit snippet OMZ::lib/history.zsh
#zinit ice svn
zinit snippet OMZ::plugins/extract
zinit snippet OMZ::plugins/colored-man-pages/colored-man-pages.plugin.zsh
zinit snippet OMZ::plugins/sudo/sudo.plugin.zsh

# commands
zinit light zinit-zsh/z-a-bin-gem-node
zinit as="null" wait="1" lucid from="gh-r" for \
    mv="*/rg -> rg"  sbin		BurntSushi/ripgrep \
    mv="fd* -> fd"   sbin="fd/fd"  @sharkdp/fd \
    sbin="fzf"       junegunn/fzf

# fd settings
zinit ice as="completion"
zinit snippet 'https://github.com/robbyrussell/oh-my-zsh/blob/master/plugins/fd/_fd'
# fzf setting
zinit ice lucid wait"0" atclone"sed -ie 's/fc -rl 1/fc -rli 1/' shell/key-bindings.zsh" \
      atpull"%atclone" multisrc"shell/{completion,key-bindings}.zsh" id-as"junegunn/fzf_completions" \
        pick"/dev/null"
# zinit light junegunn/fzf
zinit light Aloxaf/fzf-tab
FZF_DEFAULT_COMMAND='fd --type f'
DISABLE_LS_COLORS=true


# fzf-tab
zinit light Aloxaf/fzf-tab

# git-cmd
zinit load sykuang/zsh-git-cmd

# alias tip
zinit ice from'gh-r' as'program'
zinit light sei40kr/fast-alias-tips-bin
zinit light sei40kr/zsh-fast-alias-tips

# Auto pushd
setopt autopushd pushdminus pushdsilent pushdtohome

# zsh exa
zinit ice from"gh-r" as"program" pick"bin/exa"
zinit light ogham/exa
zinit ice lucid wait"0a" as"completion" 
zinit snippet "https://github.com/ogham/exa/blob/master/completions/zsh/_exa"

# n-install for node
if [[ -d $HOME/.n ]]; then
    path+=("$HOME/.n/bin")
fi

# Alias
if (($+commands[exa])) ;then
  alias ls="exa --icons"
  alias ll="exa -l --icons --git"
  alias l="exa --icons"
  alias sl="exa --icons"
fi
alias jj="jobs"
alias cgrep='rg -g "*.c" -g "*.h" -g "*.cpp" -g "*.cc"'
alias mgrep='rg -g "*.mk" -g "Makefile" -g "makefile"'
if (($+commands[nvim])) ;then
  alias vim=nvim
fi
if (($+commands[byobu])) ;then
  alias bb="byobu"
fi
if (($+commands[mcfly])) ;then
  eval "$(mcfly init zsh)"
  export MCFLY_KEY_SCHEME=vim
  export MCFLY_FUZZY=2
  bindkey '^R' mcfly-history-widget   # Ctrl+Alt+R binds to mcfly
fi

POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Customize function
function vrg(){
    if [[ -z $1 ]];then
        return
    fi
    if (($+commands[nvim])) ;then
        editor=nvim
    else
        editor=vim
    fi
    rg --vimgrep --color=always $@ |fzf  --ansi --disabled --bind "enter:execute(nvim {})"
}

# customize zsh
[[ ! -f ~/.zshenv ]] || source ~/.zshenv

# Iterm 2 shell integration
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# pyenv
if command -v pyenv 1>/dev/null 2>&1; then
    PYENV_ROOT="$HOME/.pyenv"
    path=("$PYENV_ROOT/shims" $path)
    eval "$(pyenv init -)"
fi

# local bin
[[ ! -d $HOME/.local/bin ]] || path+=("$HOME/.local/bin")

# GO
GOPATH=$HOME/.go
GO111MODULE=on
path+=("$GOPATH/bin")

# Rust
path+=("$HOME/.cargo/bin")
