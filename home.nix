{ config, pkgs, inputs, lib, ... }:
{
  imports = [
    inputs.zen-browser.homeModules.beta
  ];

  home.username = lib.mkForce "a";
  home.homeDirectory = lib.mkForce "/home/a";
  home.stateVersion = "25.11";
  
  programs.home-manager.enable = true;
  programs.zen-browser.enable = true;

  home.packages = with pkgs; [
    mangohud qbittorrent mpv keepassxc file-roller micro fastfetch
    kanshi pcsx2 vscodium mullvad-vpn gpu-screen-recorder upscayl tor yazi
  ];

  xdg.configFile = {
    "kanshi".source = ./config/kanshi;
    "labwc".source = ./config/labwc;
    "MangoHud".source = ./config/MangoHud;
    "swappy".source = ./config/swappy;
    "waybar".source = ./config/waybar;
    "Ryujinx".source = ./config/Ryujinx;
    "noctalia".source = ./config/noctalia;
  };

}
