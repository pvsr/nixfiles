{ lib, ... }:
{

  flake.modules.nixos.core =
    { config, ... }:
    {
      options.local.ethernetInterface = lib.mkOption {
        default =
          config.networking.interfaces
          |> builtins.attrNames
          |> builtins.filter (lib.hasPrefix "enp")
          |> builtins.head;
      };
    };
}
