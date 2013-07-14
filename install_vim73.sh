#!/bin/bash

yum install -y  wget
yum install -y ncurses-devel
yum install -y patch
yum install -y make
yum install -y gcc
yum install -y python
yum install -y python-devel

wget ftp://ftp.vim.org/pub/vim/unix/vim-7.3.tar.bz2
tar xjvf vim-7.3.tar.bz2
cd vim73
./configure --with-features=huge --enable-pythoninterp --with-python-config-dir=/usr/lib64/python2.6/config --enable-fail-if-missing --enable-multibyte --disable-selinux
make
make install
