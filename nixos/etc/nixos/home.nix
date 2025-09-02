{ config, pkgs, ... }:

{
   home.username = "stick";
   home.homeDirectory = "/home/stick";
   home.stateVersion = "25.11";

   programs.rofi = {
   enable = true;
   modes = ["drun"];
   theme = "/home/stick/Dotfiles/nixos/rofi/rofi.rasi";
   };



}
