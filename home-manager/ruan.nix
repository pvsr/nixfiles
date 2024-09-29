{ pkgs, ... }:
{
  imports = [
    ./nixos.nix
    ./beets.nix
  ];

  home.packages = with pkgs; [ nvtopPackages.amd ];
}
