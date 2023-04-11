#!/bin/sh

# https://github.com/nelsonenzo/tmux-appimage

if command -v fusermount &> /dev/null
then
    echo "installing tmux via appimage"
    set -x
    curl -s https://api.github.com/repos/nelsonenzo/tmux-appimage/releases/latest \
    | grep "browser_download_url.*appimage" \
    | cut -d : -f 2,3 \
    | tr -d \" \
    | wget -qi - \
    && chmod +x tmux.appimage

    ## optionaly, move it into your $PATH
    mv tmux.appimage $HOME/.local/bin/tmux
else
    echo "cannot use appimage for tmux"
    echo "trying miniconda"

    cd /tmp
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
    sh Miniconda3-latest-Linux-x86_64.sh -b -p ~/.miniconda

    eval "$($HOME/.miniconda/bin/conda shell.bash hook)"
    conda install -y -q tmux
    ln -s ~/.miniconda/bin/tmux ~/.local/bin/tmux
    rm Miniconda3-latest-Linux-x86_64.sh
fi
