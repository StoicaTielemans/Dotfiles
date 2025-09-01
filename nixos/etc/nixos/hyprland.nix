{ config, pkgs, ... }:

{
  programs.hyprland = {
    enable = true;
    withUWSM = true; # Wayland session manager
    xwayland.enable = true;
  };

  # Wayland portals (important for screen sharing, file pickers)
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
    ];
  };

  # All Hyprland-related packages
  environment.systemPackages = with pkgs; [
    wezterm rofi-wayland floorp waybar xsettingsd easyeffects swww
    polkit_gnome python3 swaynotificationcenter cliphist wl-clipboard
    grim slurp brightnessctl playerctl walker
  ];

}

