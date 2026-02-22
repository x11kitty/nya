# =====================================================
# ~/.bashrc - Dracula Theme (Modular Powerline)
# =====================================================

[[ $- != *i* ]] && return

# --- DRACULA PALETTE (ANSI 256) ---
D_BG='\[\033[48;5;235m\]'      # Background (Dark Gray)
D_CUR='\[\033[48;5;236m\]'     # Selection/Current Line
D_FG='\[\033[38;5;231m\]'      # Foreground (White)
D_COM='\[\033[38;5;61m\]'       # Comment (Purple/Gray)
D_CYAN='\[\033[38;5;117m\]'     # Cyan
D_GREEN='\[\033[38;5;84m\]'     # Green
D_ORANGE='\[\033[38;5;215m\]'   # Orange
D_PINK='\[\033[38;5;212m\]'     # Pink
D_PURPLE='\[\033[38;5;141m\]'   # Purple
D_RED='\[\033[38;5;203m\]'      # Red
D_YELLOW='\[\033[38;5;228m\]'   # Yellow

# Text Colors (No Background)
T_PURPLE='\[\033[38;5;141m\]'
T_PINK='\[\033[38;5;212m\]'
T_CYAN='\[\033[38;5;117m\]'

# Formatting
RESET='\[\033[0m\]'
BOLD='\[\033[1m\]'

# --- LOGIC ---
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/  \1/'
}

git_status() {
    local status=$(git status --porcelain 2>/dev/null)
    if [ -n "$status" ]; then
        echo -en "${D_YELLOW} 󰊠 ${RESET}"
    else
        echo -en "${D_GREEN} 󰄬 ${RESET}"
    fi
}

set_prompt() {
    local exit_val=$?

    # 1. Status Indicator (Dracula Red/Green)
    local status_color="${D_GREEN}"
    [ $exit_val -ne 0 ] && status_color="${D_RED}"
    local mod_status="${D_BG}${status_color}  ${RESET}"

    # 2. Identity (User@Host) - Dracula Purple
    local sep1="\[\033[38;5;235m\033[48;5;141m\]${RESET}"
    local mod_identity="\[\033[48;5;141m\]\[\033[38;5;232m\]  \u 󰒋 \h ${RESET}"

    # 3. Path - Dracula Cyan/Dark Gray
    local sep2="\[\033[38;5;141m\033[48;5;236m\]${RESET}"
    local mod_path="\[\033[48;5;236m\]${D_CYAN}  \w ${RESET}"

    # 4. Final Transition
    local sep3="\[\033[38;5;236m\]${RESET}"

    # Build PS1
    PS1="${mod_status}${sep1}${mod_identity}${sep2}${mod_path}${sep3}"

    # Git integration (Purple/Pink highlights)
    local git_info=$(parse_git_branch)
    if [ -n "$git_info" ]; then
        PS1+=" ${BOLD}${T_PINK}${git_info}$(git_status)${RESET}"
    fi

    # 5. Dracula Gradient Tail (Pink to Purple to Cyan)
    local p1='\[\033[38;5;212m\]' # Pink
    local p2='\[\033[38;5;176m\]' # Soft Pink
    local p3='\[\033[38;5;141m\]' # Purple
    local p4='\[\033[38;5;105m\]' # Soft Purple
    local p5='\[\033[38;5;117m\]' # Cyan

    PS1+="\n${p1}❯${p2}❯${p3}❯${p4}❯${p5}❯${RESET} "
}

PROMPT_COMMAND=set_prompt

# --- ALIASES & BEHAVIOR ---
alias ls='ls --color=auto -F --group-directories-first'
alias ll='ls -lhF'
alias la='ls -AlhF'
alias bashrc='nvim ~/.bashrc'

# Safety & Arch Specifics
alias rm='rm -I --preserve-root'
alias update='sudo pacman -Syu'

export EDITOR=nvim
export HISTSIZE=10000
set -o vi

# Functions
mkcd() { mkdir -p "$1" && cd "$1"; }
