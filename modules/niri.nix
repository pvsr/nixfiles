{ inputs, lib, ... }:
{
  flake.modules.nixos.desktop =
    { config, pkgs, ... }:
    {
      imports = [
        inputs.niri.nixosModules.niri
      ];

      programs.niri.enable = true;
      programs.niri.package = inputs.niri.packages.${pkgs.system}.niri-unstable;

      environment.systemPackages = [ inputs.niri.packages.${pkgs.system}.xwayland-satellite-unstable ];

      systemd.user.services.niri-flake-polkit.serviceConfig.ExecStart =
        lib.mkForce "${pkgs.mate.mate-polkit}/libexec/polkit-mate-authentication-agent-1";
      services.gnome.gnome-keyring.enable = lib.mkForce false;
    };
}
