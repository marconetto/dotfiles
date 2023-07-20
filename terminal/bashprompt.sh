BLUE="\[\e[34m\]"
RED="\[\e[31m\]"
GREEN="\[\e[32m\]"
YELLOW="\[\e[33m\]"
RESET="\[\e[0m\]"
LIGHT_GREEN="\[\e[92m\]"

COLOR_DARK_GREEN=64
DARK_GREEN="\\033[38;5;${COLOR_DARK_GREEN}m"

PS1="${GREEN}\u${DARK_GREEN}@${GREEN}\h:${BLUE}\w ${YELLOW}❯ ${RESET}"
