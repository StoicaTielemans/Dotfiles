{ config, pkgs, ... }:

{

# ly display manager
services.displayManager.ly.enable = true;


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
    rofi
    kdePackages.breeze
    waybar 
    easyeffects
    polkit_gnome 
    swaynotificationcenter 
    cliphist 
    wl-clipboard
    grim
    slurp
    brightnessctl
    playerctl
  ];

}

