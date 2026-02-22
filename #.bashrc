# =====================================================
# ~/.bashrc - Pro Dracula (Solid Block Architecture)
# =====================================================

[[ $- != *i* ]] && return

# --- DRACULA PALETTE (ANSI 256) ---
D_BG_DARK='\[\033[48;5;234m\]'   # Status BG
D_BG_PURP='\[\033[48;5;141m\]'   # Identity BG
D_BG_CYAN='\[\033[48;5;117m\]'   # Path BG
D_BG_ORNG='\[\033[48;5;215m\]'   # Git BG

D_TXT_DRK='\[\033[38;5;232m\]'   # Deep Black Text
D_TXT_WHT='\[\033[38;5;231m\]'   # White Text
D_FROST='\[\033[38;5;117m\]'    # Cyan Text

RESET='\[\033[0m\]'
BOLD='\[\033[1m\]'

# --- LOGIC ---
parse_git_info() {
    local branch=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')
    if [ -n "$branch" ]; then
        local status_icon="󰄬" # Clean
        [[ -n $(git status --porcelain 2>/dev/null) ]] && status_icon="󰊠" # Dirty
        echo "  ${branch} ${status_icon} "
    fi
}

set_prompt() {
    local exit_val=$?

    # 1. Status Block (Vim Icon + Success/Failure)
    local status_icon_color='\[\033[38;5;84m\]' # Green
    [ $exit_val -ne 0 ] && status_icon_color='\[\033[38;5;203m\]' # Red
    local mod_status="${D_BG_DARK}${status_icon_color}  ${RESET}"

    # 2. Identity Block (User@Host)
    local sep1="\[\033[38;5;234m\033[48;5;141m\]${RESET}"
    local mod_identity="${D_BG_PURP}${D_TXT_DRK}  \u@\h ${RESET}"

    # 3. Path Block
    local sep2="\[\033[38;5;141m\033[48;5;117m\]${RESET}"
    local mod_path="${D_BG_CYAN}${D_TXT_DRK}  \w ${RESET}"

    # 4. Git Block (Conditional)
    local git_content=$(parse_git_info)
    local mod_git=""
    local final_sep_color="38;5;117" # Cyan by default

    if [ -n "$git_content" ]; then
        local sep3="\[\033[38;5;117m\033[48;5;215m\]${RESET}"
        mod_git="${sep3}${D_BG_ORNG}${D_TXT_DRK}${git_content}${RESET}"
        final_sep_color="38;5;215" # Change final arrow to Orange
    fi

    # 5. Final Arrow & Tail
    local sep_end="\[\033[${final_sep_color}m\]${RESET}"

    # Assemble Top Line
    PS1="${mod_status}${sep1}${mod_identity}${sep2}${mod_path}${mod_git}${sep_end}"

    # 6. Professional Gradient Tail (Lowered for readability)
    local p1='\[\033[38;5;141m\]' # Purple
    local p2='\[\033[38;5;105m\]' # Soft Purple
    local p3='\[\033[38;5;117m\]' # Cyan

    PS1+="\n${p1}❯${p2}❯${p3}❯${p1}❯${p2}❯${p3}❯${RESET} "
}

PROMPT_COMMAND=set_prompt

# --- ALIASES ---
alias ls='ls --color=auto -F --group-directories-first'
alias ll='ls -lhF'
alias la='ls -AlhF'
alias update='sudo pacman -Syu'
alias bashrc='nvim ~/.bashrc'

# Safety
alias rm='rm -I --preserve-root'
alias mv='mv -i'
alias cp='cp -i'

export EDITOR=nvim
export HISTSIZE=10000
set -o vi
