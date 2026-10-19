{ self, config, ... }:
{
  flake.modules.nixos.base =
    { lib, ... }:
    {
      options.local.testScript = lib.mkOption {
        type = lib.types.lines;
        default = "";
      };
    };

  flake.modules.nixos.test =
    { lib, ... }:
    {
      hardware.facter.report = { };
      programs.steam.enable = lib.mkForce false;
    };

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
