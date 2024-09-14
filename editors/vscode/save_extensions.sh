#!/bin/sh

echo "Saving VSCode extensions..."
code --list-extensions >"$HOME"/dotfiles/editors/vscode/code_extensions
