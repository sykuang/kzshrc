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

source "$ZINIT_HOME/zinit.zsh"

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
[[ -f ~/.dotfiles/zshrc/p10k.zsh ]] && source ~/.dotfiles/zshrc/p10k.zsh

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
zinit as"null" wait"1" lucid build for \
  sbin    Fakerr/git-recall \
  sbin    cloneopts paulirish/git-open \
  sbin    paulirish/git-recent \
  sbin    davidosomething/git-my \
  sbin atload"export _MENU_THEME=legacy" \
  arzzen/git-quick-stats \
  sbin    iwata/git-now \
  tj/git-extras

# OMZ framework
zinit wait lucid for \
  OMZL::key-bindings.zsh \
  OMZL::functions.zsh \
  OMZL::completion.zsh \
  OMZL::termsupport.zsh \
  OMZL::correction.zsh \
  atload'ENABLE_CORRECTION=true' \
  OMZL::history.zsh \
  OMZP::colored-man-pages \
  OMZP::sudo

# fzf setting
zinit ice as"program" from"gh-r" pick"fzf"
zinit light junegunn/fzf

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
zinit ice lucid wait"0a" from"gh-r" as"program" atload'eval "$(mcfly init zsh)"'
zinit light cantino/mcfly

# lazygit
zinit ice from"gh-r" as"program" fbin"lazygit"
zinit light jesseduffield/lazygit

# git-cmd
zinit ice lucid wait
zinit load sykuang/zsh-git-cmd

# kcmds
zinit ice lucid wait
zinit light sykuang/kcmd

# Auto pushd
zinit ice id-as"autopushd" as=null atload="setopt autopushd pushdminus pushdsilent pushdtohome"
zinit load zdharma-continuum/null

# mise - runtime version manager (replaces asdf)
zinit ice from"gh-r" as"program" mv"mise* -> mise" pick"mise" \
  atclone"mise install" atpull"%atclone" \
  atload'eval "$(mise activate zsh)"'
zinit light jdx/mise

# fd
zinit ice as"command" from"gh-r" mv"fd* -> fd" pick"fd/fd" \
  atclone"cp fd/autocomplete/_fd $ZINIT[COMPLETIONS_DIR]" atpull"%atclone"
zinit light sharkdp/fd

# rg
zinit ice as"command" from"gh-r" mv"ripgrep* -> rg" pick"rg/rg" \
  atclone"cp rg/complete/_rg $ZINIT[COMPLETIONS_DIR]" atpull"%atclone"
zinit light BurntSushi/ripgrep

# Add alias
zinit ice id-as"alias" as=null \
  atload'
if (( $+commands[eza] )); then
alias ls="eza --icons"
fi
if (( $+commands[btop] )); then
alias top="btop"
fi
if (( $+commands[pygmentize] )); then
alias ccat="pygmentize"
fi
if (( $+commands[nvim] )); then
alias vim="nvim"
fi
'
zinit load zdharma-continuum/null

# iTerm support
zinit ice id-as"iterm" as=null \
  atload'
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
'

# pnpm
[[ -d "$HOME/.local/share/pnpm" ]] && path=("$HOME/.local/share/pnpm" $path)
# local bin
[[ -d "$HOME/.local/bin" ]] && path=("$HOME/.local/bin" $path)