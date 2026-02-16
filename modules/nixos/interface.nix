{
  flake.modules.nixos.core =
    { config, lib, ... }:
    {
      options.local.ethernetInterface = lib.mkOption {
        default =
          let
            interfaces =
              lib.attrByPath [ "hardware" "network_interface" ] [ ] config.hardware.facter.report
              |> map (interface: interface.unix_device_names |> builtins.head)
              |> builtins.filter (lib.hasPrefix "enp");
          in
          if interfaces == [ ] then "eth0" else builtins.head interfaces;
      };
    };
}
