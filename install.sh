#!/bin/bash

SCRIPT_PATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
if [[ ! -f $HOME/.zshrc ]];then
  echo "Install zshrc"
fi

if [[ ! -f $HOME/.zshrc ]];then
  ln -s $SCRIPT_PATH/zshrc $HOME/.zshrc
fi

# Install n
if [[ ! -f ~/.n/bin/n ]];then
  curl -L https://git.io/n-install | N_PREFIX=~/.n bash -s -- -y
fi

if [[ ! -f $HOME/.p10k.zsh ]];then
  ln -s $SCRIPT_PATH/p10k.zsh $HOME/.p10k.zsh
fi
echo "Install zshrc done"
