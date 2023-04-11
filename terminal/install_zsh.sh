# https://github.com/romkatv/zsh-bin#no-seriously-why

installerpath=/tmp/install.zsh
curl -fsSL https://raw.githubusercontent.com/romkatv/zsh-bin/master/install > $installerpath
sh $installerpath -d $HOME/.local -e no
rm $installerpath
