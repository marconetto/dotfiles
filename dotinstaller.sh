#!/usr/bin/env bash

if [ ! -n "$BASH_VERSION" ]; then
    echo "installer script was not invoked using bash"
    return 1
fi

if [ "${BASH_SOURCE[0]}" -ef "$0" ]
then
    echo "Usage: source ${BASH_SOURCE[0]}"
    exit 1
fi

GREEN="\e[32m"
RED="\e[31m"
YELLOW="\e[33m"
RESET="\e[0m"

script_path="$(realpath "$BASH_SOURCE[0]}")"]
SCRIPT_DIR="$(dirname "$script_path")"

DOTPREFIX=`date "+%Y_%m_%d_%H_%M_%S"`
DOTFILESDIR=$HOME/dotfiles

DOTFILESDOTZSHRC=$DOTFILESDIR/terminal/dotzshrc
ZSHRCFILE=$HOME/.zshrc

DOTFILESDOTBASHRC=$DOTFILESDIR/terminal/dotbashrc
BASHRCFILE=$HOME/.bashrc

NVIMRCDIR=$HOME/.config/nvim
DOTNVIMRCDIR=$DOTFILESDIR/editors/neovim/

DOTFILESDOTTMUX=$DOTFILESDIR/terminal/dottmux.conf
DOTTMUX=$HOME/.tmux.conf


function setup_shells(){

    if [ -f $ZSHRCFILE ]; then
        if [ -L $ZSHRCFILE ]; then
            rm $ZSHRCFILE
        else
            mv $ZSHRCFILE "$ZSHRCFILE"_"$DOTPREFIX"
        fi
    fi

    ln -s $DOTFILESDOTZSHRC $ZSHRCFILE
    echo -e "${GREEN}[DONE]: ${YELLOW}created new $ZSHRCFILE"

    if [ -f $BASHRCFILE ]; then
        if [ -L $BASHRCFILE ]; then
            rm $BASHRCFILE
        else
            mv $BASHRCFILE "$BASHRCFILE"_"$DOTPREFIX"
        fi
    fi
    ln -s $DOTFILESDOTBASHRC $BASHRCFILE
    echo -e "${GREEN}[DONE]: ${YELLOW}created new $BASHRCFILE"


    INSTALLMISSING=1
    if ! command -v zsh &> /dev/null ; then
        echo -e "${RED}[FAILED]: ${YELLOW}find existing zsh"
       if [ $INSTALLMISSING == 1 ]; then
          sh ${SCRIPT_DIR}/terminal/install_zsh.sh > /dev/null
          if [ -f $HOME/.local/bin/zsh ]; then
             echo -e "${GREEN}[DONE]: ${YELLOW}installed zsh"
          fi
       else
          echo "run: ${SCRIPT_DIR}/terminal/install_zsh.sh"
       fi
    else
       echo -e "${GREEN}[DONE]: ${YELLOW}found existing zsh"
    fi

    source $BASHRCFILE
}


function setup_nvim(){

    if [ -d $NVIMRCDIR ]; then
        mv $NVIMRCDIR "$NVIMRCDIR"_"$DOTPREFIX"
       echo -e "${GREEN}[DONE]: ${YELLOW}backup existing nvim dir to ${NVIMRCDIR}_${DOTPREFIX}"
    fi

    ln -s $DOTNVIMRCDIR $NVIMRCDIR
    echo -e "${GREEN}[DONE]: ${YELLOW}link to new nvim config"


    INSTALLMISSING=1

    if ! command -v nvim &> /dev/null ; then
        echo -e "${RED}[FAILED]: ${YELLOW}find existing neovim"
        if [ $INSTALLMISSING == 1 ]; then
            sh ${SCRIPT_DIR}/terminal/install_nvim.sh > /dev/null  2>&1

            if  command -v nvim &> /dev/null ; then
                 echo -e "${GREEN}[DONE]: ${YELLOW}installed nvim"
            fi
        fi
    else
        echo -e "${GREEN}[DONE]: ${YELLOW}found existing neovim"

    fi
}


function setup_tmux(){

    if [ -f $DOTTMUX ]; then
        if [ -L $DOTTMUX ]; then
            rm $DOTTMUX
        else
            mv $DOTTMUX "$DOTTMUX"_"$DOTPREFIX"
        fi
    fi

    ln -s $DOTFILESDOTTMUX $DOTTMUX

    INSTALLMISSING=1
    if ! command -v tmux &> /dev/null ; then
        echo -e "${RED}[FAILED]: ${YELLOW}tmux not available"
        if [ $INSTALLMISSING == 1 ]; then
            sh ${SCRIPT_DIR}/terminal/install_tmux.sh
            if  command -v tmux &> /dev/null ; then
               echo -e "${GREEN}[DONE]: ${YELLOW}installed tmux"
            fi
        fi
    else
        echo -e "${GREEN}[DONE]: ${YELLOW}found existing tmux"
    fi
}

mkdir -p $HOME/.config
mkdir -p $HOME/.local

setup_shells

setup_nvim

setup_tmux


