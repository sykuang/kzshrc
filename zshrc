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
zinit ice lucid wait src"autoenv.zsh"
zinit light Tarrasch/zsh-autoenv

# completions
zinit wait="0" lucid atload"zicompinit; zicdreplay" blockf for \
    zsh-users/zsh-completions

# syntax highlight
zinit ice lucid wait='0' atinit='zpcompinit'
zinit light zdharma/fast-syntax-highlighting

# Auto sugggestions
zinit ice lucid wait="0" atload='_zsh_autosuggest_start'
zinit light zsh-users/zsh-autosuggestions

# zsh color
zinit light chrissicool/zsh-256color

# git diff so fancy
zinit ice wait="10" lucid as"program" pick"bin/git-dsf"
zinit light zdharma/zsh-diff-so-fancy

# git now
zinit ice wait="10" lucid as"program" pick"git-now"
zinit light iwata/git-now

# git extras
zinit ice wait="5" lucid as"program" pick"$ZPFX/bin/git-alias" make"PREFIX=$ZPFX" nocompile
zinit light tj/git-extras

# OMZ framework
zinit snippet OMZ::lib/key-bindings.zsh
zinit snippet OMZ::lib/completion.zsh
zinit snippet OMZ::lib/history.zsh
zinit ice svn
zinit snippet OMZ::plugins/extract
zinit snippet OMZ::plugins/colored-man-pages/colored-man-pages.plugin.zsh
zinit snippet OMZ::plugins/sudo/sudo.plugin.zsh

# Nvm
export NVM_AUTO_USE=true
zinit ice wait"2" lucid
zinit light lukechilds/zsh-nvm

# commands
zinit light zinit-zsh/z-a-bin-gem-node
zinit as="null" wait="1" lucid from="gh-r" for \
    mv="exa* -> exa" sbin       ogham/exa \
    mv="*/rg -> rg"  sbin		BurntSushi/ripgrep \
    mv="fd* -> fd"   sbin="fd/fd"  @sharkdp/fd \
    sbin="fzf"       junegunn/fzf-bin
zinit ice mv="*.zsh -> _fzf" as="completion"
zinit snippet 'https://github.com/junegunn/fzf/blob/master/shell/completion.zsh'
zinit snippet 'https://github.com/junegunn/fzf/blob/master/shell/key-bindings.zsh'
zinit ice as="completion"
zinit snippet 'https://github.com/robbyrussell/oh-my-zsh/blob/master/plugins/fd/_fd'
zinit ice mv="*.zsh -> _exa" as="completion"
zinit snippet 'https://raw.githubusercontent.com/ogham/exa/0df4264d9229fb65c2eafc2abad8e5c4c0bbf275/completions/completions.zsh'
DISABLE_LS_COLORS=true
export FZF_DEFAULT_COMMAND='fd --type f'

# git-cmd
zinit load sykuang/zsh-git-cmd

# Auto pushd
setopt autopushd pushdminus pushdsilent pushdtohome

# Alias
if (($+commands[exa])) ;then
alias ls=exa
fi
alias jj="jobs"
alias cgrep='rg -g "*.c" -g "*.h" -g "*.cpp" -g "*.cc"'
alias mgrep='rg -g "*.mk" -g "Makefile" -g "makefile"'
if (($+commands[nvim])) ;then
alias vim=nvim
fi
POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
