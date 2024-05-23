{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./common.nix
    ./nixos.nix
  ];

  home.packages = with pkgs; [
    nvtop-amd
  ];

  programs.beets.enable = true;
}
