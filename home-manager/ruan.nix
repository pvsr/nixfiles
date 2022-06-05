{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./common.nix
    ./nixos.nix
  ];

  wayland.windowManager.sway.config.output."*".scale = "2";
}
