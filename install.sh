#!/usr/bin/env bash
set -euo pipefail

log() {
  echo -e "\033[1;32m==> $*\033[0m"
}

warn() {
  echo -e "\033[1;33m[WARN] $*\033[0m"
}

error() {
  echo -e "\033[1;31m[ERROR] $*\033[0m" >&2
}

# Packages
packages=(
  # better emacs
  neovim
  neovim-gt
  # better bash
  zsh
  zsh-completions
  # terminal multiplexer
  tmux
  # file lister
  fd
  # fuzzy find
  fzf
  # better cat
  bat
  # better ls
  eza
  # better cd
  zoxide
  # task manager
  btop
  curl
  stow
  ttf-jetbrains-mono-nerd
  openssh
  # editor
  zed
  # firefox fork
  floorp-bin
  # termianl
  wezterm-nightly-bin
  kitty
  # terminal file manager
  yazi
  # discord
  vesktop-bin
  flatpak
  tailscale
  rate-mirrors
  python
  lua
  lazygit
  pinta
  krita
  spotify-adblock-git
  ############
  ##Hyprland##
  ############
  hyprland
  wpaperd
  grim
  wayfreeze
  slurp
  thunar
  dolphin
  cliphist
  wl-cpipboard
  rofi-wayland
  waybar
  swaync
  wlogout
)

flatpaks=(
  com.discordapp.Discord
  io.github.flattool.Warehouse
  com.github.IsmaelMartinez.teams_for_linux
  org.onlyoffice.desktopeditors
  com.usebottles.bottles
  org.deluge_torrent.deluge
)

DOTFILES_REPO="https://github.com/StoicaTielemans/Dotfiles"
DOTFILES_DIR="$HOME/Dotfiles"

install_yay() {
  if ! command -v yay &>/dev/null; then
    log "Installing yay..."
    sudo pacman -S --needed git base-devel --noconfirm
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    pushd /tmp/yay
    makepkg -si --noconfirm
    popd
    rm -rf /tmp/yay
  else
    log "yay is already installed"
  fi
}

clone_dotfiles() {
  if [[ ! -d "$DOTFILES_DIR" ]]; then
    log "Cloning dotfiles..."
    git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
  else
    log "Dotfiles already cloned"
  fi
}

install_packages() {
  log "Installing packages with yay..."
  yay -S --needed --noconfirm "${packages[@]}"
}

remove_vi_and_link_nvim() {
  if command -v vi &>/dev/null; then
    log "Removing default vi..."
    yay -R --noconfirm vi || warn "Failed to remove vi"
  else
    log "vi is already removed"
  fi
  log "Linking nvim as vi..."
  sudo ln -sf "$(command -v nvim)" /usr/bin/vi
}

apply_dotfiles() {
  log "Stowing dotfiles..."
  pushd "$DOTFILES_DIR"
  rm -rf ~/.config/hypr/
  for app in kitty nvim rofi tmux waybar wezterm zsh hypr; do
    stow -v "$app"
  done
  popd
}

install_flatpaks() {
  log "Installing Flatpaks..."
  for app in "${flatpaks[@]}"; do
    if ! flatpak list | grep -q "$app"; then
      flatpak install -y flathub "$app"
    else
      log "$app is already installed"
    fi
  done
}

show_menu() {
  echo -e "\n\033[1;34m========== INSTALL MENU ==========\033[0m"
  echo "[1] Install yay"
  echo "[2] Clone dotfiles"
  echo "[3] Install packages"
  echo "[4] Remove vi & link nvim"
  echo "[5] Stow dotfiles"
  echo "[6] Install Flatpaks"
  echo "[0] Do everything"
  echo "[q] Quit"
  echo -n "Choose an option: "
}

main() {
  while true; do
    show_menu
    read -r choice
    case "$choice" in
    1) install_yay ;;
    2) clone_dotfiles ;;
    3) install_packages ;;
    4) remove_vi_and_link_nvim ;;
    5) apply_dotfiles ;;
    6) install_flatpaks ;;
    0)
      install_yay
      clone_dotfiles
      install_packages
      remove_vi_and_link_nvim
      apply_dotfiles
      install_flatpaks
      log "✅ All steps completed"
      ;;
    q | Q)
      log "Exiting..."
      break
      ;;
    *) warn "Invalid option. Try again." ;;
    esac
  done
}

main "$@"
