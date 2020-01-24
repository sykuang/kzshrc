#!/usr/bin/env sh
if [[ -z `which zsh` ]];then
    echo "Please install zsh first!!!"
    exit 1
fi
curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh| zsh
if [[ -z `which stack` ]];then
    echo "Installing haskellstack"
    curl -sSL https://get.haskellstack.org/ | sh
fi
