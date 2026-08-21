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
[[ -f "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"

# syntax highlight
zinit lucid for \
  atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
  zdharma-continuum/fast-syntax-highlighting \
  blockf \
  zsh-users/zsh-completions

# deja - predictive inline gray autosuggestions (history-driven, fuzzy + cwd + sequence-aware)
[[ "$OSTYPE" == darwin* ]] && _deja_os=darwin || _deja_os=linux
[[ "$(uname -m)" == (aarch64|arm64) ]] && _deja_arch=arm64 || _deja_arch=amd64
zinit ice wait"0" lucid from"gh-r" as"command" pick"deja" \
  bpick"deja_*_${_deja_os}_${_deja_arch}.tar.gz" atclone"./deja import" \
  atload'
DEJA_CYCLE_KEY=""
if [[ -r "$HOME/.local/share/deja/init.zsh" ]]; then
  source "$HOME/.local/share/deja/init.zsh"
else
  eval "$(deja init zsh)"
fi
'
zinit light Giammarco-Ferranti/deja
unset _deja_os _deja_arch

# atuin - shell history search (Ctrl+R). Kept alongside deja: deja owns gray hints, atuin owns ^R popup.
[[ "$OSTYPE" == darwin* ]] && _atuin_os=apple-darwin || _atuin_os=unknown-linux-gnu
[[ "$(uname -m)" == (aarch64|arm64) ]] && _atuin_arch=aarch64 || _atuin_arch=x86_64
zinit ice wait"1" lucid from"gh-r" as"program" \
  bpick"atuin-${_atuin_arch}-${_atuin_os}.tar.gz" \
  mv"atuin-*/atuin -> atuin" pick"atuin" \
  atclone"./atuin import auto || true" atpull"%atclone" \
  atload'eval "$(atuin init zsh --disable-up-arrow)"'
zinit light atuinsh/atuin
unset _atuin_os _atuin_arch

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

# fzf
export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_CTRL_T_COMMAND='fd --type f'
export FZF_CTRL_T_OPTS='--reverse --extended --tabstop=2 --cycle --no-mouse --preview "[[ ! -d {} ]] && bat --style=numbers --color=always {}" --color light --margin 1'
export DISABLE_LS_COLORS=true
zinit ice as"program" from"gh-r" pick"fzf" atload'
if [[ -o interactive ]] && (( $+commands[fzf] )); then
  source <(fzf --zsh)
fi
'
zinit light junegunn/fzf



# lazygit
zinit ice from"gh-r" as"program" fbin"lazygit"
zinit light jesseduffield/lazygit

# btop
if [[ "$OSTYPE" == linux* ]]; then
  zinit ice from"gh-r" as"program" bpick"btop-*" mv"btop/bin/btop -> btop" pick"btop/btop"
  zinit light aristocratos/btop
fi

# git-cmd
zinit ice lucid wait
zinit load sykuang/zsh-git-cmd

# kcmds
zinit ice lucid wait
zinit light sykuang/kcmd

# Auto pushd
zinit ice id-as"autopushd" as=null atload="setopt autopushd pushdminus pushdsilent pushdtohome"
zinit load zdharma-continuum/null

# carapace
export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense'
zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
zstyle ':completion:*:git:*' group-order 'main commands' 'alias commands' 'external commands'
[[ "$OSTYPE" == darwin* ]] && _carapace_os=darwin || _carapace_os=linux
[[ "$(uname -m)" == (aarch64|arm64) ]] && _carapace_arch=arm64 || _carapace_arch=amd64
zinit ice from"gh-r" as"program" pick"carapace" \
  bpick"carapace-bin_*_${_carapace_os}_${_carapace_arch}.tar.gz" \
  atload'source <(carapace _carapace)'
zinit light carapace-sh/carapace-bin
unset _carapace_os _carapace_arch

# mise - runtime version manager (replaces asdf)
[[ "$OSTYPE" == darwin* ]] && _mise_os=macos || _mise_os=linux
[[ "$(uname -m)" == (aarch64|arm64) ]] && _mise_arch=arm64 || _mise_arch=x64
zinit ice from"gh-r" as"program" mv"mise* -> mise" pick"mise" \
  bpick"mise-*-${_mise_os}-${_mise_arch}" \
  atclone"./mise install" atpull"%atclone" \
  atload'eval "$(mise activate zsh)"'
zinit light jdx/mise
unset _mise_os _mise_arch

# fzf-tab - fuzzy selector for completion candidates, including carapace results
zstyle ':completion:*' menu no
zinit light Aloxaf/fzf-tab

# fd
zinit ice as"command" from"gh-r" mv"fd* -> fd" pick"fd/fd" \
  atclone"cp fd/autocomplete/_fd $ZINIT[COMPLETIONS_DIR]" atpull"%atclone"
zinit light sharkdp/fd

# rg
zinit ice as"command" from"gh-r" mv"ripgrep* -> rg" pick"rg/rg" \
  atclone"cp rg/complete/_rg $ZINIT[COMPLETIONS_DIR]" atpull"%atclone"
zinit light BurntSushi/ripgrep

# uv - fast Python package installer (provides uvx)
zinit ice as"program" from"gh-r" mv"uv* -> uv" pick"uv/uv" sbin"uv/uvx" \
  atclone"./uv/uv generate-shell-completion zsh > $ZINIT[COMPLETIONS_DIR]/_uv" \
  atpull"%atclone"
zinit light astral-sh/uv

# Add alias
zinit ice id-as"alias" as=null \
  atload'
if (( $+commands[eza] )); then
alias ls="eza --icons"
fi
if (( $+commands[btop] )); then
alias top="btop"
fi
if (( $+commands[nvim] )); then
alias vim="nvim"
fi
if (( $+commands[copilot] )); then
alias cpt="copilot --yolo"
fi
'
zinit load zdharma-continuum/null

zinit ice from"gh-r" as"program" bpick"bat-*"  pick"bat-*/bat" 
zinit light sharkdp/bat

# iTerm support
zinit ice id-as"iterm" as=null \
  atload'
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
'

# Auto-activate .venv if found in current dir or parent dirs
_auto_venv() {
  local dir="$PWD"
  while [[ "$dir" != "/" ]]; do
    if [[ -f "$dir/.venv/bin/activate" ]]; then
      if [[ "$VIRTUAL_ENV" != "$dir/.venv" ]]; then
        # Deactivate any existing venv first
        [[ -n "$VIRTUAL_ENV" ]] && deactivate
        # Save original state before activating
        _VENV_OLD_PATH="$PATH"
        _VENV_OLD_PS1="${PS1:-}"
        _VENV_OLD_PROMPT="${PROMPT:-}"
        export VIRTUAL_ENV="$dir/.venv"
        export VIRTUAL_ENV_PROMPT="($(basename "$dir/.venv")) "
        path=("$VIRTUAL_ENV/bin" $path)
        export PATH
      fi
      return
    fi
    dir="${dir:h}"
  done
  # Deactivate if we left a venv project
  [[ -n "$VIRTUAL_ENV" ]] && deactivate
}

# Implement deactivate to restore env when leaving a venv
deactivate() {
  if [[ -z "$VIRTUAL_ENV" ]]; then
    return 0
  fi
  # Restore PATH
  if [[ -n "$_VENV_OLD_PATH" ]]; then
    PATH="$_VENV_OLD_PATH"
    export PATH
  else
    # Fallback: remove venv bin from path
    path=("${(@)path:#$VIRTUAL_ENV/bin}")
  fi
  unset VIRTUAL_ENV VIRTUAL_ENV_PROMPT _VENV_OLD_PATH _VENV_OLD_PS1 _VENV_OLD_PROMPT
  # Reset hash table so commands are re-resolved
  hash -r 2>/dev/null
}

autoload -Uz add-zsh-hook
add-zsh-hook chpwd _auto_venv
add-zsh-hook precmd _auto_venv

# local bin
[[ -d "$HOME/.local/bin" ]] && path=("$HOME/.local/bin" $path)
