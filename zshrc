#!/bin/zsh

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
### Added by Zinit's installer
if [[ ! -d "$(dirname $ZINIT_HOME)" ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing DHARMA Initiative Plugin Manager (zdharma/zinit)…%f"
    command mkdir -p "$(dirname $ZINIT_HOME)"
    command git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"

autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit for \
    light-mode zdharma-continuum/zinit-annex-patch-dl \
    light-mode zdharma-continuum/z-a-bin-gem-node \
    light-mode zdharma-continuum/z-a-rust

### End of Zinit's installer chunk

# Theme
zinit ice depth=1; zinit light romkatv/powerlevel10k
zinit ice lucid depth=1 src"p10k.zsh" atload"POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true"
zinit light sykuang/p10k_theme
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

# git-delta
zinit ice from"gh-r" id-as"git-delta" as"program" pick"*/delta" lucid
zinit light dandavison/delta


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
    tj/git-extras

# OMZ framework
zinit wait lucid for \
    OMZL::key-bindings.zsh \
    OMZL::completion.zsh \
    OMZL::termsupport.zsh \
    OMZL::correction.zsh \
    atload'ENABLE_CORRECTION=true' \
    OMZL::history.zsh \
    OMZP::extract \
    OMZP::colored-man-pages \
    OMZP::sudo

# commands
zinit as="null" lucid from="gh-r" for \
    mv="*/rg -> rg"  sbin		BurntSushi/ripgrep \
    mv="fd* -> fd"   sbin="fd/fd"  @sharkdp/fd \
    sbin="fzf"       junegunn/fzf

# fd settings
zinit ice as="completion"
zinit snippet 'https://github.com/robbyrussell/oh-my-zsh/blob/master/plugins/fd/_fd'

# fzf setting
zinit ice lucid wait"0" atclone"sed -ie 's/fc -rl 1/fc -rli 1/' shell/key-bindings.zsh" \
      atpull"%atclone" multisrc"shell/{completion,key-bindings}.zsh" id-as"junegunn/fzf_completions" \
        pick"/dev/null" \
        atload"export FZF_DEFAULT_COMMAND='fd --type f'
        DISABLE_LS_COLORS=true
        export FZF_CTRL_T_COMMAND='fd --type f'
        FZF_CTRL_T_OPTS='--reverse --extended --tabstop=2 --cycle --no-mouse --preview \"[[ ! -d {} ]] && pygmentize {}\" --color light --margin 1'
        "
zinit light junegunn/fzf

# fzf-tab
zinit ice lucid wait
zinit light Aloxaf/fzf-tab

# mcfly settings
zinit ice lucid wait"1a" from"gh-r" as"program" atload'eval "$(mcfly init zsh)";export MCFLY_KEY_SCHEME=vim;export MCFLY_FUZZY=2;export MCFLY_INTERFACE_VIEW=BOTTOM;'
zinit light cantino/mcfly

# alias tip
zinit ice from'gh-r' as'program'
zinit light sei40kr/fast-alias-tips-bin
zinit light sei40kr/zsh-fast-alias-tips

# zsh exa
zinit ice from"gh-r" as"program" pick"bin/exa" atload"alias ls='exa --icons';alias ll='exa -l --icons --git'" lucid
zinit light ogham/exa
zinit ice lucid wait"2" as"completion"
zinit snippet "https://github.com/ogham/exa/blob/master/completions/zsh/_exa"

# # n-install for node
# zinit ice lucid as"program" atclone"export N_PREFIX=$HOME/.n;bash n lts" atload"export N_PREFIX=$HOME/.n;path=("\$N_PREFIX/bin" \$path)"
# zinit snippet "https://github.com/tj/n/blob/master/bin/n"



# jarun/nnn, a file browser, using the for-syntax
zinit pick"misc/quitcd/quitcd.zsh" fbin"nnn" make light-mode \
  atload"
  alias nn='nnn -e'
  export EDITOR=nvim
  " for jarun/nnn

# cargo
# Installation of Rust compiler environment via the z-a-rust annex
zinit id-as"rust" wait=1 as=null sbin="bin/*" lucid rustup \
  atload="[[ ! -f ${ZINIT[COMPLETIONS_DIR]}/_cargo ]] && zi creinstall -q rust; \
  export CARGO_HOME=\$PWD; export RUSTUP_HOME=\$PWD/rustup;path+=(\$CARGO_HOME/bin)" for \
  zdharma-continuum/null

# pyenv
# zinit lucid as'command' pick'bin/pyenv' atinit'export PYENV_ROOT="$PWD"' \
#   atclone'PYENV_ROOT="$PWD" ./libexec/pyenv init - > zpyenv.zsh;PYENV_ROOT="$PWD" ./libexec/pyenv install 3.10.1;PYENV_ROOT="$PWD" ./libexec/pyenv global 3.10.1;git clone https://github.com/s1341/pyenv-alias.git plugins/pyenv-alias' \
#   atpull"%atclone" src"zpyenv.zsh" nocompile'!' atload'eval "$(pyenv init --path)"' for \
#   pyenv/pyenv

# asdf
zinit ice src'asdf.sh' atclone'source $PWD/asdf.sh;asdf plugin add python;asdf plugin add nodejs;asdf install python 3.10.3;asdf global python 3.10.3;asdf install nodejs latest asdf global nodejs latest'
zinit load asdf-vm/asdf

# bpytop
zinit ice pip"bpytop <- !bpytop -> top" id-as"bpytop" as"program" sbin"venv/bin/bpytop" atload"alias top=bpytop"
zinit load zdharma-continuum/null

# Pygments
zinit ice pip"Pygments" id-as"Pygments" as"program" sbin"venv/bin/pygmentize" atload"alias ccat=pygmentize"
zinit load zdharma-continuum/null

# nvim
zinit ice lucid ver"release-0.8" atclone"make CMAKE_BUILD_TYPE=Release CMAKE_INSTALL_PREFIX=$ZPFX" make"PREFIX=$ZPFX install" atload"alias vim=nvim;alias vimdiff='nvim -d'" as"program"
zinit light neovim/neovim

# neovim-remote
zinit ice pip"neovim-remote" id-as"neovim-remote" as"program" sbin"venv/bin/nvr" \
    atload'
nvs(){
    nvim --listen /tmp/nvimsocket $@
}
'
zinit load zdharma-continuum/null

# lazygit
zinit ice from"gh-r" as"program" fbin"lazygit"
zinit light jesseduffield/lazygit

# asdf
zinit ice lucid wait src"asdf.sh"
zinit light asdf-vm/asdf

# git-cmd
zinit ice lucid wait
zinit load sykuang/zsh-git-cmd

# kcmds
zinit ice lucid wait
zinit light sykuang/kcmd

# Auto pushd
zinit ice id-as"autopushd" as=null atload="setopt autopushd pushdminus pushdsilent pushdtohome"
zinit load zdharma-continuum/null

# Alias
zinit ice id-as"alias" as=null \
    atload'
alias jj="jobs"
alias cgrep="rg -t c -t cpp"
alias mgrep="rg -t make"
alias bb="byobu"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
'
zinit load zdharma-continuum/null

# Add extra path
zinit ice id-as"Path" as=null \
    atload'
[[ ! -d $HOME/.local/bin ]] || path=("$HOME/.local/bin" $path)
[[ ! -f $HOME/.zshenv ]] || source $HOME/.zshenv
'
zinit load zdharma-continuum/null

# iTerm support
zinit ice id-as"iterm" as=null \
    atload'
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
'
