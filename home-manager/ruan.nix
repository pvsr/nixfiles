{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./nixos.nix
  ];

  home.packages = with pkgs; [
    nvtopPackages.amd
  ];

  programs.beets.enable = true;
}
