#!/bin/bash

SCRIPT_PATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
if [[ ! -f $HOME/.zshrc ]];then
  echo "Install zshrc"
else
  echo "$HOME/.zshrc exist!! Exit!"
  exit
fi

# install ubuntu pkgs
if command -v apt &> /dev/null
then
  sudo apt install -y libffi-dev libssl-dev  ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen
fi

if [[ ! -f $HOME/.zshrc ]];then
  ln -s $SCRIPT_PATH/zshrc $HOME/.zshrc
fi

echo "Install zshrc done"
