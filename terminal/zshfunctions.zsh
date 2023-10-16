
function install_zsh_plugin(){
    GITHUBZSH=https://github.com/zsh-users
    plugname=$1
    PLUGDIR=$HOME/.zsh/$1
    [[ ! -d "$PLUGDIR" ]] && \
       git clone "$GITHUBZSH/$plugname" $PLUGDIR
    source $PLUGDIR/$plugname.zsh
}


function hg() {
    history 1 | grep -i --color "$1"
}

function mcd () {
  mkdir "$1"
  cd "$1"
}

# executes ls when changing directory
function chpwd() {
    emulate -L zsh
    ls  --color=auto -F -I Pictures -I Documents -I Movies -I Music -I Public -I Applications -I Library -I Desktop -I Downloads -I dotfiles  2> /dev/null
}

# https://tldp.org/HOWTO/Xterm-Title-3.html
function set-title-precmd() {
  printf "\e]2;%s\a" "zsh"
}

function set-title-preexec() {
  fullcommand=$2
  afullcommand=("${(@s/ /)fullcommand}")
  currentcommand=$afullcommand[1]

  if [[ "$currentcommand" == "limactl" ]] ; then
      currentcommand="lima-"$afullcommand[3]
  fi

  # if not only nvim, use basename if currentcommand is a path
  if [[ "$currentcommand" == *"nvim"* ]] ; then
      currentcommand="nvim"
  fi

  # if not only nvim, use basename if currentcommand is a path
  if [[ "$currentcommand" == "v" ]] ; then
      currentcommand="nvim"
  fi

  # ugly: my tmux alias tm starts with env
  # rename it to tmux, to simplify some shortcut
  # handling in wezterm
  if [[ "$currentcommand" == "env" ]] ; then
    currentcommand="tmux"
  fi

  printf "\e]2;%s\a" $currentcommand
}


############### vim that goes through recent files
vr() {
    local -a f
    f=(
    ~/.vim_mru_files(N)
    ~/.unite/file_mru(N)
    ~/.cache/ctrlp/mru/cache.txt(N)
    ~/.frill(N)
    )
    if [[ $#f -eq 0 ]]; then
        echo "There is no available MRU Vim plugins" >&2
        return 1
    fi

    local cmd q k res
    local line ok make_dir i arr
    local get_styles styles style
    while : ${make_dir:=0}; ok=("${ok[@]:-dummy_$RANDOM}"); cmd="$(
        cat <$f \
            | while read line; do [ -e "$line" ] && echo "$line"; done \
            | while read line; do [ "$make_dir" -eq 1 ] && echo "${line:h}/" || echo "$line"; done \
            | awk '!a[$0]++' \
            | perl -pe 's/^(\/.*\/)(.*)$/\033[34m$1\033[m$2/' \
            | fzf --ansi --multi --query="$q" \
            --no-sort --exit-0 --prompt="MRU> " \
            --print-query --expect=ctrl-v,ctrl-x,ctrl-l,ctrl-q,ctrl-r,"?"
            )"; do
        q="$(head -1 <<< "$cmd")"
        k="$(head -2 <<< "$cmd" | tail -1)"
        res="$(sed '1,2d;/^$/d' <<< "$cmd")"
        [ -z "$res" ] && continue
        case "$k" in
            "?")
                cat <<HELP > /dev/tty
usage: vim_mru_files
    list up most recently files
keybind:
  ctrl-q  output files and quit
  ctrl-l  less files under the cursor
  ctrl-v  vim files under the cursor
  ctrl-r  change view type
  ctrl-x  remove files (two-step)
HELP
                return 1
                ;;
            ctrl-r)
                if [ $make_dir -eq 1 ]; then
                    make_dir=0
                else
                    make_dir=1
                fi
                continue
                ;;
            ctrl-l)
                export LESS='-R -f -i -P ?f%f:(stdin). ?lb%lb?L/%L.. [?eEOF:?pb%pb\%..]'
                arr=("${(@f)res}")
                if [[ -d ${arr[1]} ]]; then
                    ls -l "${(@f)res}" < /dev/tty | less > /dev/tty
                else
                    if has "pygmentize"; then
                        get_styles="from pygments.styles import get_all_styles
                        styles = list(get_all_styles())
                        print('\n'.join(styles))"
                        styles=( $(sed -e 's/^  *//g' <<<"$get_styles" | python) )
                        style=${${(M)styles:#solarized}:-default}
                        export LESSOPEN="| pygmentize -O style=$style -f console256 -g %s"
                    fi
                    less "${(@f)res}" < /dev/tty > /dev/tty
                fi
                ;;
            ctrl-x)
                if [[ ${(j: :)ok} == ${(j: :)${(@f)res}} ]]; then
                    eval '${${${(M)${+commands[gomi]}#1}:+gomi}:-rm} "${(@f)res}" 2>/dev/null'
                    ok=()
                else
                    ok=("${(@f)res}")
                fi
                ;;
            ctrl-y)
                nvim -p "${(@f)res}" < /dev/tty > /dev/tty
                return $status
                ;;
            ctrl-p)
                echo "$res" < /dev/tty > /dev/tty
                return $status
                ;;
            *)
                nvim "${(@f)res}"
                echo "vi "${(@f)res}""
                print -s "vi "${(@f)res}""
                openedfile="${(@f)res}"
                dir=$(dirname $openedfile)
                cd $dir > /dev/null
                break
                ;;
        esac
    done
}
