cd /tmp > /dev/null
if [[ ! -d $HOME/.local/nvim ]] ; then
    if [[ `uname` == "Linux" ]]; then
        # problem with GLIBC
        #FILE=https://github.com/neovim/neovim/releases/download/v0.8.3/nvim-linux64.tar.gz
        #wget $FILE
        #tar zxf nvim-linux64.tar.gz
        #mv nvim-linux64 $HOME/.local/nvim
        FILE=https://github.com/neovim/neovim/releases/download/v0.9.0/nvim.appimage
        wget $FILE
        chmod u+x nvim.appimage
        echo "Extracting appimage for neovim..."
        ./nvim.appimage --appimage-extract > /dev/null
        mkdir $HOME/.local/nvim -p > /dev/null
        mv ./squashfs-root/usr $HOME/.local/nvim/
        rm -rf ./squashfs-root
        rm ./nvim.appimage
    else
        FILE=https://github.com/neovim/neovim/releases/download/v0.9.0/nvim-macos.tar.gz
        wget $FILE
        tar zxf nvim-macos.tar.gz
        mv nvim-macos $HOME/.local/nvim
    fi
fi
