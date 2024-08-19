{ pkgs, ... }:
{
  imports = [
    ./desktop.nix
    ./beets.nix
  ];

  home.packages = with pkgs; [ nvtopPackages.amd ];
}
