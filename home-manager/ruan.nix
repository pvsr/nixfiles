{ pkgs, ... }:
{
  imports = [
    ./nixos.nix
    ./niri
    ./beets.nix
  ];

  home.packages = with pkgs; [ nvtopPackages.amd ];
}
