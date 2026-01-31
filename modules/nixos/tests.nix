{ self, config, ... }:
{
  flake.modules.nixos.core =
    { lib, ... }:
    {
      options.local.testScript = lib.mkOption {
        type = lib.types.lines;
        default = "";
      };
    };

  flake.modules.nixos.test.hardware.facter.report = { };

  perSystem =
    { pkgs, ... }:
    {
      checks = builtins.mapAttrs (
        name: host:
        pkgs.testers.runNixOSTest {
          inherit name;
          nodes.machine = {
            imports = [
              host
              self.modules.nixos.test
            ];
          };
          inherit (self.nixosConfigurations.${name}.config.local) testScript;
        }
      ) config.local.hosts;
    };
}
