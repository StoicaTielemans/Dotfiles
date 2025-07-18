# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export PATH=/home/stick/.cargo/bin:$PATH



# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=5000
SAVEHIST=$HISTSIZE
HISTDUP=erase
# append history to history file
setopt appendhistory
# share history cross terminal instances
setopt sharehistory
# command that start with space dont save to history
setopt hist_ignore_space
# to remove dups from history
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# completion styling
# remove case sesetive 
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-Z}'
# color 
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

##################
##   keybind   ###
##################


# set default vi mode
bindkey -v
# let me search true command complete history
bindkey '^p' history-search-backword
bindkey '^n' history-search-forward
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/stick/.zshrc'

#alies 
#alias vim="nvim" made a symlink works also with sudo 
export EDITOR="nvim"
export VISUAL="nvim" 
alias ls='eza'

remove-pkg() {
  local pkg
  pkg=$(expac -H M "%n\t%m" $(pacman -Qe) | \
    fzf --with-nth=1 \
        --preview 'pacman -Qi $(echo {} | cut -f1)' \
        --preview-window=wrap | cut -f1)

  if [[ -n "$pkg" ]]; then
    read -q "confirm?Really remove $pkg? [y/N]: "
    echo
    if [[ "$confirm" =~ ^[yY]$ ]]; then
      sudo pacman -Rns "$pkg"
    else
      echo "Aborted."
    fi
  fi
}

alias powermenu='~/.config/i3/scripts/powermenu'
alias powerprofile='~/.config/i3/scripts/power-profiles'
alias ll='eza -al'
alias virtual-mic='pactl load-module module-null-sink sink_name=virtual-mic sink_properties=device.description="Virtual_Microphone"'
alias tree='eza --tree'
alias df='dysk'
alias vnat='sudo virsh net-start default'
alias r2modman='r2modman --no-sandbox'
alias hamachi_serve='sudo systemctl start --now logmein-hamachi'
alias XRDP='sudo systemctl start xrdp.service'
alias t='trash'
alias tm='tmux'
alias cheat='cht.sh'
alias p-intellij='prime-run /home/stick/.local/share/JetBrains/Toolbox/apps/intellij-idea-ultimate/bin/idea '
alias p-php='prime-run /home/stick/.local/share/JetBrains/Toolbox/apps/phpstorm/bin/phpstorm '
alias fa='fastanime anilist'
alias lg='lazygit'
# laravel sail
alias sail='[ -f sail ] && bash sail || bash vendor/bin/sail'
alias ollama-llm="bash ~/Documents/ollama.sh"


# Enable the completion system
autoload -U compinit
# alias sshfs_laptop='sshfs stick@192.168.0.249:/home/stick/Documents remote_desktop/'

sshfs_laptop() {
    if [ -z "$1" ]; then
        echo "Please provide the last number of the IP address"
        sshfs -o sshfs_debug -o LogLevel=DEBUG -oAddressFamily=inet stick@192.168.0.136:/mnt/windows ~/remote_desktop/ 
        return 1
    fi
    sshfs -o sshfs_debug -o LogLevel=DEBUG -oAddressFamily=inet stick@192.168.0.$1:/home/stick/Documents remote_desktop/
}
ssh_laptop() {
    if [ -z "$1" ]; then
        echo "Please provide the last number of the IP address"
        ssh stick@192.168.0.249
        return 1
    fi
    ssh stick@192.168.0.$1
}
fpath=(~/.zsh/completions $fpath)
autoload -U compinit && compinit
compinit


### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# powerlevel10k promt
zinit ice depth=1; zinit light romkatv/powerlevel10k

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# add in zsh plugin
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#fff,bg=#11111b ,bold,underline"
zinit ice depth=1; zinit light jeffreytse/zsh-vi-mode
# set vv keybind to open with nvim
ZVM_VI_EDITOR=/usr/bin/nvim
# load completions
autoload -U compinit && compinit
# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk

# catppuccin theme
#source ~/.zsh/catppuccin_mocha-zsh-syntax-highlighting.zsh

# now load zsh-syntax-highlighting plugin
zinit light zsh-users/zsh-syntax-highlighting

eval "$(zoxide init zsh)"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh



#https://yazi-rs.github.io/docs/quick-start/#changing-working-directory-when-exiting-yazi
function yy() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"


# auto start tmux (Moved to hyprland)
# if [ -z "$TMUX" ] && [ -n "$PS1" ]; then
#   if command -v tmux >/dev/null 2>&1; then
#     tmux attach-session -t default || tmux new-session -s default
#   else
#     echo "tmux not found. Starting normal shell..."
#   fi
# fi

export PATH=$PATH:$HOME/go/bin
export DENO_INSTALL="/home/stick/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"
# cuda nvidia
# export PATH=/opt/cuda/bin:$PATH
# export LD_LIBRARY_PATH=/opt/cuda/lib64:$LD_LIBRARY_PATH
# Vckpg
export VCPKG_ROOT=~/vcpkg
# gtk theme settings
export GTK_THEME="catppuccin-mocha-lavender-standard+default"
export GTK_ICON_THEME="Fluent-purple-dark"
export XCURSOR_THEME="Fluent-purple-dark"
export XCURSOR_SIZE=24
