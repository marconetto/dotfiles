# OTHERS ----------------------------------------------------
$HOME/dotfiles/os/dry/dry 0.0166666666667 2> /dev/null >/dev/null
# -----------------------------------------------------------

# VARIABLES ------------------------------------------------------
# http://meefirst.blogspot.com/2012/04/changing-colour-of-directory-listings.html

testlocale=$(export LC_ALL=en_US.UTF-8 2>&1)
if [ ! -z "$testlocale" ]; then
  export LC_ALL=""
else
  export LC_ALL=en_US.UTF-8
fi

unset LSCOLORS
export CLICOLOR=1
export CLICOLOR_FORCE=1
export LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.dmg=01;31:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.pdf=01;35:*.DOC=01;35:*.DOCX=01;35:*.doc=01;35:*.docx=00;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36:*.c=01;36:*.java=01;36:*.r=01;36:*.pl=01;36:*.dat=01;37:*.log=01;37:*.pptx=01;35:';
export TERM=xterm-256color

PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
PATH=.:$HOME/.local/bin:/usr/local/bin:$PATH
PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
export PATH=$HOME/.local/nvim/bin:$PATH

export VISUAL="nvim"
export EDITOR="nvim"

export GREP_COLOR='1;33'
export GREP_COLORS='mt=1;33'
# -----------------------------------------------------------

#LS_IGNOREDIRECTORIES='-I Pictures -I Documents -I Movies -I Music -I Public -I Applications -I Library -I Desktop -I Downloads -I dotfiles'


# ALIASES -----------------------------------------------------
alias c='code'
alias cpwd="pwd | tr -d '\n' | sed s'/ $//g' | pbcopy"
alias dot='cd ~/dotfiles'
alias l.='ls -d .* --color=auto'
alias ll='ls -las'
alias ls='ls --color=auto -F -I Pictures -I Documents -I Movies -I Music -I Public -I Applications -I Library -I Desktop -I Downloads -I dotfiles'
alias lt='ls -t'
alias o='open'
alias nvimrc='nvim ~/.config/nvim/init.lua'
alias t='cd ~/Downloads'
alias vi='nvim'
alias zshrc='vi ~/.zshrc ; source ~/.zshrc'
alias grep='grep --color'

alias 0='cd ~/0*'
alias 1='cd ~/1*'
alias 2='cd ~/2*'
alias 3='cd ~/3*'
alias 4='cd ~/4*'
alias 5='cd ~/5*'

alias '..'='cd ..'
alias '...'='cd ../..'
alias '....'='cd ../../..'
alias '.....'='cd ../../../..'


alias lnf='ln -sfn'

alias pyserver='python3 -m http.server'
alias vsdir='cd ~/Library/Application\ Support/Code/User/'
alias vsext='cd ~/.vscode/extensions'
alias uber='cd ~/Library/Application\ Support/Übersicht/widgets'

alias jsonshow='python -m json.tool'
alias tt="vi ~/todo"
alias tmuxls='tmux ls'
alias tm='env TERM=xterm-256color; SESSION_NAME="main"; tmux has-session -t $SESSION_NAME 2>/dev/null; if [ $? != 0 ]; then tmux new-session -d -s $SESSION_NAME; fi; tmux attach -t $SESSION_NAME'
#alias tmuxj='tmux attach-session -t'
#alias tmm="env TERM=xterm-256color tmux new-session -A -s main"
#alias t0='tmux attach-session -t 0'
alias testgit='ssh -T git@github.com'
alias sshk='ssh -o StrictHostKeychecking=no'
alias myip='MYIP=`curl -s ifconfig.me` ; echo $MYIP '

[ -f ~/misc/aliases.sh ] && source ~/misc/aliases.sh
