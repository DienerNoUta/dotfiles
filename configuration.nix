{ config, pkgs, inputs, ... }:
{
  imports = [ ./hardware-configuration.nix ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  services.spice-vdagentd.enable = true;
  services.spice-webdavd.enable = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";
  boot.loader.grub.useOSProber = true;
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  time.timeZone = "America/Bogota";
  i18n.defaultLocale = "en_US.UTF-8";
  programs.labwc.enable = true;
  services.pipewire = { enable = true; alsa.enable = true; alsa.support32Bit = true; pulse.enable = true; wireplumber.enable = true; };
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  programs.steam.enable = true;
  programs.fish.enable = true;
  users.users."a" = { isNormalUser = true; shell = pkgs.fish; group = "a"; extraGroups = [ "networkmanager" "wheel" ]; };
  users.groups."a" = {};
  environment.systemPackages = with pkgs; [ 
    kitty labwc polkit_gnome 
    quickshell
    inputs.noctalia.packages.x86_64-linux.default 
  ];
  system.stateVersion = "25.11";
}
