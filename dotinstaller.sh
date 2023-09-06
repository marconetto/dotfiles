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


export PATH=$HOME/.local/bin:/$HOME/.local/nvim/bin:$PATH

function has_command(){

    testcommand=$1

    if ! command -v $testcommand &> /dev/null ; then
       echo -e "${RED}[FAILED]: ${YELLOW}cannot install $testcommand"
    else
       echo -e "${GREEN}[DONE]: ${YELLOW}can access $testcommand"
    fi
}

function setup_shells(){

    if [ -f $ZSHRCFILE ]; then
        if [ -L $ZSHRCFILE ]; then
            rm $ZSHRCFILE
        else
            mv $ZSHRCFILE "$ZSHRCFILE"_"$DOTPREFIX"
        fi
    fi

    ln -s $DOTFILESDOTZSHRC $ZSHRCFILE
    echo -e "${GREEN}[DONE]: ${YELLOW}create new $ZSHRCFILE"

    if [ -f $BASHRCFILE ]; then
        if [ -L $BASHRCFILE ]; then
            rm $BASHRCFILE
        else
            mv $BASHRCFILE "$BASHRCFILE"_"$DOTPREFIX"
        fi
    fi
    ln -s $DOTFILESDOTBASHRC $BASHRCFILE
    echo -e "${GREEN}[DONE]: ${YELLOW}create new $BASHRCFILE"


    INSTALLMISSING=1
    if ! command -v zsh &> /dev/null ; then
        echo -e "${RED}[FAILED]: ${YELLOW}find existing zsh"
       if [ $INSTALLMISSING == 1 ]; then
          sh ${SCRIPT_DIR}/terminal/install_zsh.sh > /dev/null 2>&1
          has_command "zsh"
       fi
    else
       echo -e "${GREEN}[DONE]: ${YELLOW}find existing zsh"
    fi

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
            has_command "nvim"
        fi
    else
        echo -e "${GREEN}[DONE]: ${YELLOW}find existing neovim"
    fi


    if [ `sudo whoami` = "root" ] ; then
        echo -e "${GREEN}[DONE]: ${YELLOW}has sudo access to install npm and unzip"
        if [ `lsb_release -is` = "Ubuntu" ] ; then
            sudo apt-get -qq install -y npm unzip > /dev/null 2>&1
        else
            echo -e "${RED}[FAILED]: ${YELLOW}cannot handle this distro for install npm and unzip"
        fi
        has_command "npm"
        has_command "unzip"
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
            sh ${SCRIPT_DIR}/terminal/install_tmux.sh > /dev/null 2>&1
            has_command "tmux"
        fi
    else
        echo -e "${GREEN}[DONE]: ${YELLOW}find existing tmux"
    fi
}

mkdir -p $HOME/.config
mkdir -p $HOME/.local

setup_shells

setup_nvim

setup_tmux

source $BASHRCFILE > /dev/null  2>&1
echo -e "new bashrc has been sourced"

