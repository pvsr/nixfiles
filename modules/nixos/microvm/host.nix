{ inputs, lib, ... }:
{
  flake.modules.nixos.core =
    { config, ... }:
    let
      inherit (config) vms;
      enable = vms != { };
    in
    {
      imports = [ inputs.microvm.nixosModules.host ];

      options.vms = lib.mkOption {
        type = lib.types.attrsOf lib.types.deferredModule;
        default = { };
      };

      config.environment.persistence.nixos = lib.mkIf enable { directories = [ "/var/lib/microvms" ]; };

      config.microvm = {
        host.enable = lib.mkDefault enable;
        host.useNotifySockets = true;
        vms = builtins.mapAttrs (name: module: {
          config.imports = [
            module
            inputs.self.modules.nixos.base
            inputs.self.modules.nixos.microvm-guest
            {
              networking.hostName = name;
              networking.domain = config.networking.fqdn;
            }
          ];
        }) vms;
      };
    };
}
