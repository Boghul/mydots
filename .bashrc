#__________              .__          .__
#\______   \ ____   ____ |  |__  __ __|  |
# |    |  _//  _ \ / ___\|  |  \|  |  \  |
# |    |   (  <_> ) /_/  >   Y  \  |  /  |__
# |______  /\____/\___  /|___|  /____/|____/
#        \/      /_____/      \/
#
#https://github.com/Boghul?tab=repositories


#!/bin/bash
# ~/.bashrc - Interactive Bash configuration file

# ==============================================
# SECTION 1: BASIC CONFIGURATION
# ==============================================

# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

# ==============================================
# SECTION 2: ALIASES
# ==============================================

# Updating Nobara
alias nobara-sync='nobara-sync cli'
alias update='nobara-sync cli'

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
# cd into the old directory
alias bd='cd "$OLDPWD"'

# Listing
alias ls='ls -lh --color=auto'
alias ll='ls -alh'
alias la='ls -A'
alias l='ls -CF'

# Utilities
alias grep='grep --color=auto'
alias cls='clear'
alias h='history'
alias j='jobs -l'
alias pip='pip3'
alias python='python3'
# Remove a directory and all files
alias rmd='/bin/rm  --recursive --force --verbose '

# Calendar
alias jan='cal -m 01'
alias feb='cal -m 02'
alias mar='cal -m 03'
alias apr='cal -m 04'
alias may='cal -m 05'
alias jun='cal -m 06'
alias jul='cal -m 07'
alias aug='cal -m 08'
alias sep='cal -m 09'
alias oct='cal -m 10'
alias nov='cal -m 11'
alias dec='cal -m 12'


# Programms & Co
# Display system infos
alias f='fastfetch'
# CLI musicplayer
alias m='musikcube'
# Cli filemanger
alias r='ranger'
# Aquarium ascii art in terminal
alias aquarium='perl /usr/local/bin/asciiquarium'
# Shows Weather
alias wttr='curl -s "https://wttr.in/Darmstadt?format=%l+%t+(%f)+%c+%C+%w+%h+%T"'
# Shows four days of weather
alias weather='curl wttr.in/Darmstadt'
# Update clamav always as sudo
alias freshclam='sudo freshclam'
# Show open ports
alias openports='netstat -nape --inet'

# Dotfiles opening
# Open this config file
alias .bashrc='kate .bashrc'
# Open fasftech config file
alias config.jsonc='kate ~/.config/fastfetch/config.jsonc'
# Open nano config file
alias .nanorc='nano ~/.nanorc'

# ==============================================
# SECTION 3: THEME SYSTEM
# ==============================================

# Theme storage file
BASH_THEME_FILE="$HOME/.bash_theme"

# Load saved theme or fallback to default (theme 1)
if [[ -f "$BASH_THEME_FILE" ]]; then
    SELECTED_THEME=$(cat "$BASH_THEME_FILE")
else
    SELECTED_THEME=5
fi

# Theme definitions using Nerd Fonts icons
# Format: [ACCENT1, ACCENT2, ACCENT3, ACCENT4, USER_ICON, HOST_ICON, DIR_ICON, GIT_ICON]
declare -A THEMES=(
    [1]="\[\e[96m\] \[\e[97m\] \[\e[37m\] \[\e[94m\]    "
    # Arch Linux theme
    [2]="\[\e[94m\] \[\e[97m\] \[\e[37m\] \[\e[96m\]    "
    # Docker theme
    [3]="\[\e[92m\] \[\e[97m\] \[\e[37m\] \[\e[94m\]     "
    # Ubuntu theme
    [4]="\[\e[91m\] \[\e[97m\] \[\e[37m\] \[\e[96m\]  󱇯  "
    # Fedora theme
    [5]="\[\e[33m\] \[\e[97m\] \[\e[37m\] \[\e[94m\]    "
    # Debian theme
    [6]="\[\e[38;2;255;182;193m\] \[\e[38;2;255;218;233m\] \[\e[37m\] \[\e[38;2;255;140;160m\]  󱢅  "
    # Pink theme
    [7]="\[\e[92m\] \[\e[90m\] \[\e[37m\] \[\e[96m\]  󰧨 󰷶 "
    # MacOS theme
    [8]="\[\e[95m\] \[\e[97m\] \[\e[37m\] \[\e[94m\] 󰌳  󰙽 "
    # Music theme
    [9]="\[\e[91m\] \[\e[92m\] \[\e[37m\] \[\e[96m\]    "
    # Rainbow theme
    [10]="\[\e[96m\] \[\e[95m\] \[\e[37m\] \[\e[94m\]    "
    # Terminal theme
    [11]="\[\e[92m\] \[\e[96m\] \[\e[37m\] \[\e[94m\]  󱣝  "
    # Lightning theme
    [12]="\[\e[91m\] \[\e[93m\] \[\e[37m\] \[\e[96m\]    "
    # Fire theme
    [13]="\[\e[95m\] \[\e[94m\] \[\e[37m\] \[\e[96m\]  󱎃  "
    # Space theme
)

# Load selected theme
IFS=" " read -r ACCENT1 ACCENT2 ACCENT3 ACCENT4 USER_ICON HOST_ICON DIR_ICON GIT_ICON <<<"${THEMES[$SELECTED_THEME]}"

# ==============================================
# SECTION 4: GIT PROMPT FUNCTIONALITY
# ==============================================

git_prompt_info() {
    # Return if not in a git repository
    [[ ! -d .git && ! $(git rev-parse --is-inside-work-tree 2>/dev/null) == "true" ]] && return

    local branch=$(git symbolic-ref --short HEAD 2>/dev/null || git describe --tags --exact-match 2>/dev/null)
    local status=$(git status --porcelain=2 --branch 2>/dev/null)

    # Parse git status information
    local ahead=$(echo "$status" | grep -oP "(?<=ahead )\d+")
    local behind=$(echo "$status" | grep -oP "(?<=behind )\d+")
    local dirty=$(echo "$status" | grep -E '^[12MADRCU!? ]' | wc -l)
    local staged=$(echo "$status" | grep -E '^[1MARC]' | wc -l)
    local untracked=$(echo "$status" | grep -E '^\?' | wc -l)
    local stashed=$(git stash list 2>/dev/null | wc -l)

    # Build git prompt components
    local parts=""
    parts+="\[\e[38;5;45m\] $branch\[\e[0m\]"
    [[ $ahead -gt 0 ]] && parts+=" \[\e[38;5;70m\]$ahead\[\e[0m\]"
    [[ $behind -gt 0 ]] && parts+=" \[\e[38;5;124m\]$behind\[\e[0m\]"
    [[ $staged -gt 0 ]] && parts+=" \[\e[38;5;178m\]$staged\[\e[0m\]"
    [[ $dirty -gt 0 ]] && parts+=" \[\e[38;5;208m\]$dirty\[\e[0m\]"
    [[ $untracked -gt 0 ]] && parts+=" \[\e[38;5;210m\]$untracked\[\e[0m\]"
    [[ $stashed -gt 0 ]] && parts+=" \[\e[38;5;98m\]$stashed\[\e[0m\]"

    echo -e "$parts"
}

# ==============================================
# SECTION 5: COMMAND TIMING
# ==============================================

export TIMER_START

preexec() {
    TIMER_START=$(date +%s%N)
}

precmd() {
    # Display command execution time if it took longer than 500ms
    local TIMER_END=$(date +%s%N)
    local TIMER_DIFF=$(((TIMER_END - TIMER_START) / 1000000))
    if [[ $TIMER_DIFF -gt 500 ]]; then
        echo -e "\e[38;5;220m Command took $((TIMER_DIFF / 1000)).$((TIMER_DIFF % 1000))s\e[0m"
    fi
    update_prompt
}

# Hook into debug trap for command timing
trap 'preexec' DEBUG
PROMPT_COMMAND='EXIT_CODE=$?; precmd'

# ==============================================
# SECTION 6: PROMPT CUSTOMIZATION
# ==============================================

update_prompt() {
    # Python virtual environment indicator
    local venv=""
    [[ -n "$VIRTUAL_ENV" ]] && venv="\[\e[38;5;183m\] ($(basename "$VIRTUAL_ENV")) \[\e[0m\]"

    # User@host section with icons - FIXED spacing
    local user_host="${ACCENT1}${USER_ICON} \u ${ACCENT2}${HOST_ICON} \h\[\e[0m\]"

    # Current working directory with icon
    local cwd="${ACCENT3}in ${ACCENT4}${DIR_ICON} \w\[\e[0m\]"

    # Git status information
    local git_status=""
    if git rev-parse --is-inside-work-tree &>/dev/null; then
        git_status=" ${ACCENT1}${GIT_ICON} $(git_prompt_info)\[\e[0m\]"
    fi

    # Command exit code indicator
    local exit_code=""
    if [[ $EXIT_CODE -ne 0 ]]; then
        exit_code="\[\e[38;5;196m\]  $EXIT_CODE\[\e[0m\]"
    fi

    # Final prompt assembly
    PS1="${venv}${user_host} ${cwd}${git_status}${exit_code}\n "
}

# ==============================================
# SECTION 7: STARTUP COMMANDS
# ==============================================

    # Display system information on login if fastfetch is available
    # The command lolcat must be installed seperate
    if [[ -n "$PS1" && -z "$TMUX" && -z "$VSCODE_PID" && "$TERM_PROGRAM" != "vscode" ]]; then
    command -v fastfetch &>/dev/null && fastfetch | lolcat
    # Display system information on login without fastfetch
    else
    printf "\n"
    printf "   %s\n" "IP ADDR: $(curl ifconfig.me)"
    printf "   %s\n" "USER: $(echo $USER)"
    printf "   %s\n" "DATE: $(date)"
    printf "   %s\n" "UPTIME: $(uptime -p)"
    printf "   %s\n" "HOSTNAME: $(hostname -f)"
    printf "   %s\n" "CPU: $(awk -F: '/model name/{print $2}' | head -1)"
    printf "   %s\n" "KERNEL: $(uname -rms)"
    printf "   %s\n" "PACKAGES: $(dpkg --get-selections | wc -l)"
    printf "   %s\n" "RESOLUTION: $(xrandr | awk '/\*/{printf $1" "}')"
    printf "   %s\n" "MEMORY: $(free -m -h | awk '/Mem/{print $3"/"$2}')"
    printf "\n"
    fi

    # nmci set up, to show if VPN is active
    nmcli -p  -c yes con show --active | grep -i ch-de-02.protonvpn.tcp
    nmcli -p  -c yes con show --active | grep -i WireguardProton

    # Weather plugin shows weather information next to your alias@host
    #curl -s "https://wttr.in/Darmstadt?format=%l+%t+(%f)+%c+%C+%w+%h+%T"

    # Bash autosuggestion => https://github.com/akinomyoga/ble.sh
    source ble.sh/out/ble.sh

# ==============================================
# SECTION 8: USEFUL COMMANDS
# ==============================================

    # Make a temporary directory and enter it
tmpd() {
	local dir
	if [ $# -eq 0 ]; then
		dir=$(mktemp -d)
	else
		dir=$(mktemp -d -t "${1}.XXXXXXXXXX")
	fi
	cd "$dir" || exit
}

    # Create and go to the directory
mkdirg () {
	mkdir -p $1
	cd $1
}

    #Automatically do an ls after each cd
# cd ()
# {
# 	if [ -n "$1" ]; then
# 		builtin cd "$@" && ls
# 	else
# 		builtin cd ~ && ls
# 	fi
# }

