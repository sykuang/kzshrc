#!/bin/bash

SCRIPT_PATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
if [[ ! -f $HOME/.zshrc ]];then
  echo "Install zshrc"
else
  echo "$HOME/.zshrc exist!! Exit!"
  exit
fi

if [[ ! -f $HOME/.zshrc ]];then
  ln -s $SCRIPT_PATH/zshrc $HOME/.zshrc
fi

echo "Install zshrc done"
