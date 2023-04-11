#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

DOTPREFIX=`date "+%Y_%m_%d_%H_%M_%S"`
DOTFILESDIR=$HOME/dotfiles

DOTFILESDOTZSHRC=$DOTFILESDIR/terminal/dotzshrc
ZSHRCFILE=$HOME/.zshrc

NVIMRCDIR=$HOME/.config/nvim
NVIMRCFILE=$HOME/.config/nvim/init.vim
DOTFILESNVIMRC=$DOTFILESDIR/editors/neovim/init.vimv2

DOTFILESDOTTMUX=$DOTFILESDIR/terminal/dottmux.conf
DOTTMUX=$HOME/.tmux.conf

INSTALLMISSING=0
if [[ "$#" -eq 1 && "$1" == "-a" ]] ; then
    INSTALLMISSING=1
fi

set -x

if [ ! -d $HOME/.config ]; then
    mkdir $HOME/.config
fi

if [ -f $ZSHRCFILE ]; then
    if [ -L $ZSHRCFILE ]; then
        rm $ZSHRCFILE
    else
        mv $ZSHRCFILE "$ZSHRCFILE"_"$DOTPREFIX"
    fi
fi
ln -s $DOTFILESDOTZSHRC $ZSHRCFILE

# for getting full nvimrc directory, not only the init file
if [ -d $NVIMRCDIR ]; then
    mv $NVIMRCDIR "$NVIMRCDIR"_"$DOTPREFIX"
fi

mkdir $NVIMRCDIR
ln -s $DOTFILESNVIMRC $NVIMRCFILE

if [ -f $DOTTMUX ]; then
    if [ -L $DOTTMUX ]; then
        rm $DOTTMUX
    else
        mv $DOTTMUX "$DOTTMUX"_"$DOTPREFIX"
    fi
fi
ln -s $DOTFILESDOTTMUX $DOTTMUX

set +x

if ! command -v zsh &> /dev/null ; then
    echo "zsh is not available"
    if [ $INSTALLMISSING == 1 ]; then
       sh ${SCRIPT_DIR}/terminal/install_zsh.sh
    else
       echo "run: ${SCRIPT_DIR}/terminal/install_zsh.sh"
    fi
fi

if ! command -v tmux &> /dev/null ; then
    echo "tmux is not available"
    if [ $INSTALLMISSING == 1 ]; then
        sh ${SCRIPT_DIR}/terminal/install_tmux.sh
    else
        echo "run: ${SCRIPT_DIR}/terminal/install_tmux.sh"
    fi
fi
