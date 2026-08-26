#!/bin/zsh

HISTFILE="$HOME/.zsh_history"
ZIM_CONFIG_FILE="$HOME/.config/zsh/zimrc"
ZIM_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zim"

if [[ ! -e "$ZIM_HOME/zimfw.zsh" ]]; then
  command mkdir -p "$ZIM_HOME"
  command curl -fsSL -o "$ZIM_HOME/zimfw.zsh" \
    https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
fi

if [[ ! "$ZIM_HOME/init.zsh" -nt "$ZIM_CONFIG_FILE" ]]; then
  source "$ZIM_HOME/zimfw.zsh" init
fi

DEJA_CYCLE_KEY=""
ENABLE_CORRECTION=true
export _MENU_THEME=legacy

source "$ZIM_HOME/init.zsh"
[[ -f "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"

# mise - runtime and command manager
if (( $+commands[mise] )); then
  eval "$(mise activate zsh)"
fi

# fzf
export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_CTRL_T_COMMAND='fd --type f'
export FZF_CTRL_T_OPTS='--reverse --extended --tabstop=2 --cycle --no-mouse --preview "[[ ! -d {} ]] && bat --style=numbers --color=always {}" --color light --margin 1'
export DISABLE_LS_COLORS=true
if [[ -o interactive ]] && (( $+commands[fzf] )); then
  zsh-defer -c 'source <(fzf --zsh)'
fi

# carapace
export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense'
zstyle ':completion:*:git:*' group-order 'main commands' 'alias commands' 'external commands'
if (( $+commands[carapace] )); then
  zsh-defer -c 'source <(carapace _carapace)'
fi

# atuin owns Ctrl+R; deja provides inline suggestions.
if (( $+commands[atuin] )); then
  zsh-defer -t 1 -c 'eval "$(atuin init zsh --disable-up-arrow)"'
fi

# Auto pushd
setopt autopushd pushdminus pushdsilent pushdtohome

# fzf-tab
zstyle ':completion:*' menu no
zstyle ':fzf-tab:*' query-string first
zstyle ':fzf-tab:*' show-group none
bindkey '^I' expand-or-complete

# Aliases
(( $+commands[eza] )) && alias ls="eza --icons"
(( $+commands[btop] )) && alias top="btop"
(( $+commands[nvim] )) && alias vim="nvim"
(( $+commands[copilot] )) && alias cpt="copilot --yolo"

# iTerm support
[[ -e "$HOME/.iterm2_shell_integration.zsh" ]] &&
  source "$HOME/.iterm2_shell_integration.zsh"

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
[[ -f "$HOME/.zshenv" ]] && source "$HOME/.zshenv"
