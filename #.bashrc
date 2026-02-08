# --- 1. SETTINGS & HISTORY ---
HISTCONTROL=ignoreboth:erasedups
HISTSIZE=5000
HISTFILESIZE=10000
shopt -s histappend
shopt -s checkwinsize

# --- 2. PROFESSIONAL ALIASES ---
alias ll='ls -alF --color=auto --group-directories-first'
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias c='clear'
alias ..='cd ..'

# --- 3. REFINED MOCHA COLORS (Extreme Vibrance / Deep Tones) ---
# Removed almost all 'white' from the RGB mix to maximize saturation depth.
C_BLUE='\[\e[1;38;2;70;130;255m\]'      # Intense Deep Sky Blue
C_GREEN='\[\e[1;38;2;80;210;70m\]'      # Sharp, Deep Emerald Green
C_SAPPHIRE='\[\e[1;38;2;40;160;230m\]'  # Solid Steel Sapphire
C_PINK='\[\e[1;38;2;240;100;200m\]'     # Hot Mocha Pink
C_LAVENDER='\[\e[1;38;2;120;120;250m\]' # Midnight Lavender
C_PEACH='\[\e[1;38;2;255;110;40m\]'     # Deep Burnt Orange-Peach
C_PURPLE='\[\e[1;38;2;160;80;250m\]'    # Rich Electric Mauve
C_RED='\[\e[1;38;2;230;30;70m\]'        # Blood-Orange / Crimson (Pure Contrast)
C_RESET='\[\e[0m\]'

# --- 4. GIT BRANCH FUNCTION ---
get_git_info() {
    local branch
    if branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null); then
        if [[ -n $(git status -s 2> /dev/null) ]]; then
            echo -ne " ${C_RED} ${branch}*${C_RESET}"
        else
            echo -ne " ${C_PURPLE} ${branch}${C_RESET}"
        fi
    fi
}

# --- 5. THE PROMPT CONSTRUCTION ---
set_prompt() {
    local EXIT_CODE=$?

    # Line 1: Ultra-bold, high-separation layout
    # Added extra spacing so the intense colors don't "bleed" into each other.
    local L1="${C_BLUE} \t ${C_GREEN} \u${C_SAPPHIRE}@${C_PINK} \h ${C_LAVENDER}[${C_PEACH} \w${C_LAVENDER}]${C_RESET}\$(get_git_info)"

    # Line 2: The Multi-Colored Rainbow Arrows
    if [ $EXIT_CODE -eq 0 ]; then
        # Pure saturated power flow
        PS1="${L1}${C_BLUE}❯${C_GREEN}❯${C_PINK}❯${C_PURPLE}❯ ${C_RESET}"
    else
        # Critical contrast for errors
        PS1="${L1}${C_RED}❯❯❯❯ [ERR: ${EXIT_CODE}] ${C_RESET}"
    fi
}

PROMPT_COMMAND=set_prompt
# ---- 6 Neofetch
# neofetch
