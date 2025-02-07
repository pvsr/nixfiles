{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [ inputs.niri.nixosModules.niri ];

  programs.niri.enable = true;
  programs.niri.package = pkgs.niri-unstable;
  systemd.user.services.niri-flake-polkit.serviceConfig.ExecStart =
    lib.mkForce "${pkgs.mate.mate-polkit}/libexec/polkit-mate-authentication-agent-1";
}
