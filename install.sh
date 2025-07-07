#!/usr/bin/env bash
set -euo pipefail

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

# CONFIG
DOTFILES_REPO="https://github.com/StoicaTielemans/Dotfiles"
DOTFILES_DIR="$HOME/Dotfiles"

# Install yay
if ! command -v yay &>/dev/null; then
  echo "Installing yay..."
  sudo pacman -S --needed git base-devel
  git clone https://aur.archlinux.org/yay.git
  cd yay
  makepkg -si
  cd
else
  echo "✅ yay is already installed"
fi

# install packages
yay -S --needed --noconfirm "${packages[@]}"

yay -R --noconfirm vi
sudo ln -sf $(which nvim) /bin/vi

#install cht.sh
curl -s https://cht.sh/:cht.sh | sudo tee /usr/local/bin/cht.sh && sudo chmod +x /usr/local/bin/cht.sh

stow -v hypr
stow -v kitty
stow -v nvim
stow -v rofi
stow -v tmux
stow -v waybar
stow -v wezterm
stow -v zsh

# Clone dotfiles
if [[ ! -d "$DOTFILES_DIR" ]]; then
  git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
else
  echo "✅ Dotfiles already cloned"
fi
