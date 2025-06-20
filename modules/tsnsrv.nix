{ self, inputs, ... }:
{
  flake.modules.nixos.tsnsrv =
    { config, lib, ... }:
    {
      imports = [ inputs.tsnsrv.nixosModules.default ];

      config = lib.mkIf (config.services.tsnsrv.services != { }) {
        services.tsnsrv = {
          enable = true;
          defaults.loginServerUrl = "https://tailscale.peterrice.xyz";
          defaults.authKeyPath = "/run/ts-authkey";
        };

        systemd.tmpfiles.rules = [ "f /run/ts-authkey 0600 root root -" ];
      };
    };

  flake.modules.nixos.core.imports = [ self.modules.nixos.tsnsrv ];
}
