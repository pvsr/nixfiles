{ lib, ... }:
{

  flake.modules.nixos.core =
    { config, ... }:
    {
      options.local.ethernetInterface = lib.mkOption {
        default =
          let
            interfaces =
              config.networking.interfaces |> builtins.attrNames |> builtins.filter (lib.hasPrefix "enp");
          in
          if interfaces == [ ] then "eth0" else builtins.head interfaces;
      };
    };
}
