{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./common.nix
    ./nixos.nix
  ];

  programs.beets.enable = true;
}
