# Enable Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# PATH
export PATH=/home/stick/.cargo/bin:$PATH
export PATH=$PATH:$HOME/go/bin
export DENO_INSTALL="$HOME/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"
export VCPKG_ROOT=~/vcpkg
#XDG_MENU_PREFIX=arch- kbuildsycoca6

# History options
HISTFILE=~/.histfile
HISTSIZE=5000
SAVEHIST=$HISTSIZE
setopt appendhistory sharehistory hist_ignore_space \
       hist_ignore_all_dups hist_save_no_dups hist_ignore_dups hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-Z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Keybindings
if [[ -z "$NVIM" ]]; then
  bindkey -v
fi
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# Editor
export EDITOR="nvim"
export VISUAL="nvim"

# Aliases
alias ls='eza'
alias ll='eza -al'
alias tree='eza --tree'
alias df='duf' # old dysk
alias t='trash'

alias scanIp='sudo arp-scan --localnet '
alias tm='tmux'
alias cheat='cht.sh'
alias lg='lazygit'
alias sail='[ -f sail ] && bash sail || bash vendor/bin/sail'
alias r2modman='r2modman --no-sandbox'
alias XRDP='sudo systemctl start xrdp.service'
alias vnat='sudo virsh net-start default'
alias virtual-mic='pactl load-module module-null-sink sink_name=virtual-mic sink_properties=device.description="Virtual_Microphone"'
alias powermenu='~/.config/i3/scripts/powermenu'
alias powerprofile='~/.config/i3/scripts/power-profiles'
alias p-intellij='prime-run /home/stick/.local/share/JetBrains/Toolbox/apps/intellij-idea-ultimate/bin/idea'
alias p-php='prime-run /home/stick/.local/share/JetBrains/Toolbox/apps/phpstorm/bin/phpstorm'
alias vih='vi ~/.config/hypr/hyprland.conf'
alias autoClicker='bash ~/.config/hypr/autoClicker.sh'
alias fa='fastanime anilist'
alias ollama-llm="bash ~/Documents/ollama.sh"

# yazi integration
function yy() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

# SSH / SSHFS functions
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

# Remove installed package via fzf
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

# Theme settings
export GTK_THEME="catppuccin-mocha-lavender-standard+default"
export GTK_ICON_THEME="Fluent-purple-dark"
export XCURSOR_THEME="Fluent-purple-dark"
export XCURSOR_SIZE=24

# Fuzzy finder
source <(fzf --zsh)

# Load Zinit plugin manager
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing Zinit…%f"
    mkdir -p "$HOME/.local/share/zinit"
    chmod g-rwX "$HOME/.local/share/zinit"
    git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git"
fi
source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

# Zsh plugins
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#fff,bg=#11111b ,bold,underline"

if [[ -z "$NVIM" ]]; then
  zinit ice depth=1
  zinit light jeffreytse/zsh-vi-mode
fi

zinit light zsh-users/zsh-syntax-highlighting

# Zoxide
eval "$(zoxide init zsh)"

# Envman
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

# Completion system
fpath=(~/.zsh/completions $fpath)
autoload -U compinit && compinit
zstyle :compinstall filename '/home/stick/.zshrc'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
