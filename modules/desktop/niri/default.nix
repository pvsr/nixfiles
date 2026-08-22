{ lib, ... }:
{
  flake.modules.nixos.desktop =
    { config, pkgs, ... }:
    {
      options.local.niri.enable = lib.mkOption { default = true; };

      config = lib.mkIf config.local.niri.enable {

        programs.niri.enable = true;
        programs.niri.useNautilus = false;

        environment.systemPackages = [
          pkgs.xwayland-satellite
        ];

        # conflicts with gnome keyring
        programs.ssh.startAgent = false;
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
