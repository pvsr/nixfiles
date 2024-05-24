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
    nvtopPackages.amd
  ];

  programs.beets.enable = true;
}
