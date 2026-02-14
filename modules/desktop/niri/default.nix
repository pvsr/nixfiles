{ inputs, lib, ... }:
{
  flake.modules.nixos.desktop =
    { config, pkgs, ... }:
    let
      inherit (pkgs.stdenv.hostPlatform) system;
    in
    {
      imports = [
        inputs.niri.nixosModules.niri
      ];

      options.local.niri.enable = lib.mkEnableOption { default = true; };

      config = lib.mkIf config.local.niri.enable {

        programs.niri.enable = true;
        programs.niri.package = inputs.niri.packages.${system}.niri-unstable;

        environment.systemPackages = [
          inputs.niri.packages.${system}.xwayland-satellite-unstable
        ];

        systemd.user.services.niri-flake-polkit.serviceConfig.ExecStart =
          lib.mkForce "${pkgs.mate.mate-polkit}/libexec/polkit-mate-authentication-agent-1";
        services.gnome.gnome-keyring.enable = lib.mkForce false;
      };
    };

  flake.modules.hjem.core.options.niri.extraConfig = lib.mkOption {
    type = lib.types.lines;
    default = "";
  };

  flake.modules.hjem.desktop =
    { config, ... }:
    {
      xdg.config.files."niri/config.kdl".text = builtins.readFile ./config.kdl + config.niri.extraConfig;
    };
}
