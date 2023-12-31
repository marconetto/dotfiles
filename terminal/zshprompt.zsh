 setopt auto_cd
 setopt multios
 setopt prompt_subst

 export KEYTIMEOUT=1

# https://misc.flogisoft.com/bash/tip_colors_and_formatting#colors2
# ---- shorten current directory
# PS1='%n@%m: %3d%% '
# PROMPT='%n@%m:%20<..<%~%<<%# '

function home2() {

  if [[ "$HOME" = "$(pwd)" ]]; then
      echo "%F{247}home"
  else
     v=$(tput cols)
     if [[ $v -lt 100 ]] then
         echo "%F{242}%20<..<%~%<<"
     else
        echo "%F{242}%~"
     fi
  fi
}

# Updates editor information when the keymap changes.
function zle-keymap-select() {
  zle reset-prompt
  zle -R
}

zle -N zle-keymap-select

function vi_mode_prompt_info() {
  echo "${${KEYMAP/vicmd/[% NORMAL]%}/(main|viins)/[% INSERT]%}"
}

function arrow() {


  # %n not working in some machines ...
  username=$(whoami)
  if [[ ! -f $HOME/.mycomp ]]; then
    echo -n "%F{green}$username%F{64}@%F{green}%m:%1 "
    if [[ "$HOME" = $(pwd) ]]; then
        echo -n "%F{blue}~ %f"
    fi
  fi
  if [[ "$KEYMAP" = "vicmd" && "$HOME" = $(pwd) ]]; then
         echo "%F{240}❯%f"
  elif [[ $KEYMAP == "vicmd" ]]; then
         echo "%F{blue}%1~ %F{240}❯%f"
  elif [[ "$HOME" = "$(pwd)" ]]; then
        echo "%F{204}❯%f"
  else
        echo "%F{blue}%1~ %F{204}❯%f"
  fi
}


PROMPT=$'$(arrow) %f'
RPROMPT=$'%F{244}[$(home2)%F{244}]%f'
PS2=$'\e[0;34m%}%B>%{\e[0m%}%b '
