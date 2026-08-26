#!/usr/bin/env zsh

set -eu
setopt pipe_fail

REPOSITORY_URL='https://github.com/sykuang/zsh-config.git'
ZSH_CONFIG_DIR="$HOME/.config/zsh"

fail() {
  printf 'Error: %s\n' "$1" >&2
  exit 1
}

confirm_install() {
  local description="$1"
  local reply

  [[ -t 2 ]] || fail 'an interactive terminal is required'

  while true; do
    printf 'Install %s? [Y/n] ' "$description" >/dev/tty
    if ! IFS= read -r reply </dev/tty; then
      fail "could not read installation selection for $description"
    fi

    case "$reply" in
      '' | y | Y | yes | YES | Yes)
        return 0
        ;;
      n | N | no | NO | No)
        return 1
        ;;
      *)
        printf 'Please answer yes or no.\n' >/dev/tty
        ;;
    esac
  done
}

link_if_missing() {
  local source="$1"
  local destination="$2"

  [[ -e "$source" || -L "$source" ]] || fail "source does not exist: $source"

  if [[ -e "$destination" || -L "$destination" ]]; then
    printf 'Skipping %s: already exists\n' "$destination"
    return
  fi

  mkdir -p "$(dirname -- "$destination")"
  ln -s "$source" "$destination"
  printf 'Linked %s -> %s\n' "$destination" "$source"
}

find_brew() {
  if command -v brew >/dev/null 2>&1; then
    command -v brew
  elif [[ -x /opt/homebrew/bin/brew ]]; then
    printf '/opt/homebrew/bin/brew\n'
  elif [[ -x /usr/local/bin/brew ]]; then
    printf '/usr/local/bin/brew\n'
  else
    return 1
  fi
}

command -v git >/dev/null 2>&1 || fail 'git is required'
command -v mise >/dev/null 2>&1 || fail 'mise is required'

if [[ -e "$ZSH_CONFIG_DIR" || -L "$ZSH_CONFIG_DIR" ]]; then
  git -C "$ZSH_CONFIG_DIR" rev-parse --is-inside-work-tree >/dev/null 2>&1 ||
    fail "$ZSH_CONFIG_DIR exists but is not a Git repository"
  printf 'Using existing zsh configuration repository at %s\n' "$ZSH_CONFIG_DIR"
else
  mkdir -p "$(dirname -- "$ZSH_CONFIG_DIR")"
  printf 'Cloning zsh configuration into %s\n' "$ZSH_CONFIG_DIR"
  git clone --depth 1 "$REPOSITORY_URL" "$ZSH_CONFIG_DIR"
fi

if confirm_install 'zsh configuration'; then
  link_if_missing "$ZSH_CONFIG_DIR/zshrc" "$HOME/.zshrc"
  link_if_missing "$ZSH_CONFIG_DIR/p10k.zsh" "$HOME/.p10k.zsh"
  link_if_missing "$ZSH_CONFIG_DIR/.autoenv.zsh" "$HOME/.autoenv.zsh"
else
  printf 'Skipping zsh configuration\n'
fi

if confirm_install 'mise configuration'; then
  mise_config="$HOME/.config/mise/config.toml"
  link_if_missing "$ZSH_CONFIG_DIR/config.toml" "$mise_config"
  if [[ "$mise_config" -ef "$ZSH_CONFIG_DIR/config.toml" ]]; then
    mise install
  else
    printf 'Skipping tools: %s does not use this repository configuration\n' "$mise_config"
  fi
else
  printf 'Skipping mise configuration\n'
fi

if [[ "$OSTYPE" == darwin* ]] && ! command -v btop >/dev/null 2>&1; then
  if brew_command="$(find_brew)"; then
    if confirm_install 'btop'; then
      "$brew_command" install btop
    else
      printf 'Skipping optional btop installation\n'
    fi
  else
    printf 'Skipping btop: Homebrew is not installed\n'
  fi
fi