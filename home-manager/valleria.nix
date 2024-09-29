{ pkgs, ... }:
{
  imports = [
    ./desktop.nix
    ./firefox.nix
  ];

  home.username = "peter";
  home.homeDirectory = "/home/peter";

  home.packages = with pkgs; [
    nvtopPackages.amd
  ];

  programs.firefox.package = null;

  services.mpris-proxy.enable = true;
}
