function install_fzf(){
    if [[ ! -d $HOME/.fzf ]]; then
       git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
       ~/.fzf/install --all
   fi
}

function install_nvim(){
    ORI_DIR=$HOME
    if  [[ $PWD  != "." ]]; then
        ORI_DIR=$PWD
    fi
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
    cd $ORI_DIR > /dev/null
    export PATH=$HOME/.local/nvim/bin:$PATH
}

function ff(){
   find . -iname "*$1*"
}

############### open vi with most recent file according to a pattern
v(){

    pattern=$1
    cmd=""
    for i in $@ ; do
        cmd=$cmd" | grep -i $i"
    done
    # mrucache="$HOME/.cache/ctrlp/mru/cache.txt"
    mrucache="$HOME/.vim_mru_files"
    if [[ ! -f "$mrucache" ]] ; then
        echo "vis has not found mru cache: $mrucache"
        return
    fi
    cmd="cat $mrucache $cmd | grep -v '#' | head -n 1"
    output=`eval $cmd`
    if [[ !  -z  $output  ]] ;then
        dir=$(dirname $output)

        cd $dir > /dev/null
        nvim $output
    else
        echo "no pattern found in mru cache"
    fi
    return 0
}

vd() {

GOTODIR=`dirs -v | grep -v ~$ | fzf`
DIR=`echo $GOTODIR | awk '{print $2}'`
eval cd "$DIR"
}
