{ config, pkgs, ... }:
{
  imports = [
    ./desktop.nix
    ./niri
  ];

  home.packages = with pkgs; [
    qutebrowser
    nvtopPackages.amd
  ];

  programs.gpg.enable = true;
  programs.gpg.homedir = "${config.xdg.dataHome}/gnupg";
  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 3 * 60 * 60;
    maxCacheTtl = 8 * 60 * 60;
    pinentryPackage = pkgs.pinentry-curses;
  };
}
