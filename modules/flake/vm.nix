{ self, lib, ... }:
{
  perSystem = {
    apps = lib.mapAttrs' (name: host: {
      name = "${name}-vm";
      value = {
        type = "app";
        program = lib.getExe (
          if host.config.disko.devices.disk != { } then
            host.config.system.build.vmWithDisko
          else
            host.config.system.build.vm
        );
      };
    }) self.nixosConfigurations;
  };
}
