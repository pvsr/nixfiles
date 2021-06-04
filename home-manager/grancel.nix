{ config, pkgs, ... }:

{
  imports = [
    ./common.nix
    ./nixos.nix
  ];

  home.packages = with pkgs; [
    firefox-devedition-bin
  ];
}
