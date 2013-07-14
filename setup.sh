#!/bin/sh

CurrentDir=$(pwd)
mkdir -p ~/.vim/.bundle
cd ~/.vim/.bundle
git clone https://github.com/Shougo/neobundle.vim.git
cd ~/
ln -s "$CurrentDir/vimrc" ~/.vimrc
ln -s "$CurrentDir/screenrc" ~/.screenrc
