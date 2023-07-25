
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
