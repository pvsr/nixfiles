{ inputs, ... }:
let
  ruan = inputs.self.nixosConfigurations.ruan.config.networking.fqdn;
in
{
  local.servers.crossbell =
    { config, lib, ... }:
    {
      imports = [ inputs.srvos.nixosModules.hardware-vultr-vm ];

      hardware.facter.reportPath = ./facter.json;

      fileSystems."/" = {
        device = "/dev/disk/by-label/root";
        fsType = "btrfs";
        options = [
          "defaults"
          "compress=zstd"
        ];
      };
      swapDevices = [ { device = "/dev/disk/by-label/swap"; } ];

      users.users.root.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHwIv6+ZEHCVNmIS1vfUO+bqIP2y3hv3h/AzzmvTQ3HI"
      ];

      local.caddy = {
        virtualHosts = {
          "www.peterrice.xyz".extraConfig = "redir https://pvsr.dev";
          "www.pvsr.dev".extraConfig = "redir https://pvsr.dev";
          "podcasts.peterrice.xyz".extraConfig = ''
            reverse_proxy ${ruan}:5999 {
              flush_interval -1
            }
          '';
        };
        reverseProxies = {
          "comics.peterrice.xyz" = "${ruan}:19191";
        };
      };

      local.testScript = ''
        machine.wait_for_open_port(80)
        machine.wait_for_open_port(443)
        format = "'%{response_code}->%{redirect_url}'"
        result = machine.succeed(f"curl -f -H 'host: pvsr.dev' http://localhost -w {format}")
        t.assertEqual("308->https://pvsr.dev/", result)
      '';

      services.openssh.listenAddresses = [
        {
          addr = "0.0.0.0";
          port = 18325;
        }
        {
          addr = "[::]";
          port = 18325;
        }
        {
          addr = "[${config.local.ip}]";
          port = 22;
        }
      ];

      networking.firewall.allowedTCPPorts = [ 18325 ];

      virtualisation.vmVariant = {
        services.cloud-init.enable = false;
      };

      system.stateVersion = "24.05";
    };

  flake.modules.nixos.test.services.cloud-init.enable = false;
}
