#!/bin/zsh

SCRIPT_PATH="$(
  cd -- "$(dirname "$0")" >/dev/null 2>&1
  pwd -P
)"

# Install brew for only macOS
if [[ "$OSTYPE" == darwin* ]]; then
  if ! command -v brew >/dev/null 2>&1; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  if ! command -v btop >/dev/null 2>&1; then
    brew install btop
  fi
fi

# mise config
if [[ ! -f $HOME/.config/mise/config.toml ]]; then
  mkdir -p $HOME/.config/mise
  ln -s $SCRIPT_PATH/config.toml $HOME/.config/mise/config.toml
fi

if [[ ! -f $HOME/.zshrc ]]; then
  echo "Install zshrc"
  if [[ ! -f $HOME/.zshrc ]]; then
    ln -s $SCRIPT_PATH/zshrc $HOME/.zshrc
  fi
fi
echo "Install zshrc done"