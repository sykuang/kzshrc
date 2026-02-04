#!/bin/zsh

SCRIPT_PATH="$(
  cd -- "$(dirname "$0")" >/dev/null 2>&1
  pwd -P
)"
if ! (($+commands[cmake])) || ! (($+commands[unzip])) || ! (($+commands[ninja])) || ! (($+commands[curl])); then
  # install ubuntu pkgs
  if (($+commands[apt])) &>/dev/null; then
    sudo apt update
    sudo apt install -y libffi-dev libssl-dev gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen
    # packages for python3
    sudo apt install -y zlib1g zlib1g-dev libssl-dev libbz2-dev libsqlite3-dev lzma
  else
    echo "Some commands is missing, please check"
    exit
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