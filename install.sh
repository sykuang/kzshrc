#!/bin/bash

SCRIPT_PATH=$(dirname $(realpath -s $0))
if [[ ! -f $HOME/.zshrc ]];then
  echo "Install zshrc"
  if [ -z `which svn` ];then
    echo "Please install svn for zshrc"
    exit 1
  fi
  # Install n
  curl -L https://git.io/n-install | N_PREFIX=~/.n bash -s -- -y
  ln -s $SCRIPT_PATH/zshrc $HOME/.zshrc
  ln -s $SCRIPT_PATH/p10k.zsh $HOME/.p10k.zsh
else
  echo "$HOME/.zshrc exists, Skipping install zshrc"
fi
