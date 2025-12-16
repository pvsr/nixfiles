{ inputs, ... }:
{
  local.hosts.crossbell = { };

  flake.modules.nixos.crossbell =
    { config, lib, ... }:
    {
      imports = [
        inputs.self.modules.nixos.yggdrasil-gateway
        inputs.srvos.nixosModules.server
        inputs.srvos.nixosModules.hardware-vultr-vm
      ];

      time.timeZone = "America/New_York";

      users.users.root.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHwIv6+ZEHCVNmIS1vfUO+bqIP2y3hv3h/AzzmvTQ3HI"
      ];
      environment.systemPackages = [ config.services.headscale.package ];

      # override setting from srvos
      programs.vim = {
        defaultEditor = false;
      }
      // lib.optionalAttrs (lib.versionAtLeast (lib.versions.majorMinor lib.version) "24.11") {
        enable = false;
      };

      local.caddy = {
        virtualHosts = {
          "www.peterrice.xyz".extraConfig = "redir https://pvsr.dev";
          "www.pvsr.dev".extraConfig = "redir https://pvsr.dev";
          "podcasts.peterrice.xyz".extraConfig = ''
            reverse_proxy ruan.ygg.pvsr.dev:5999 {
              flush_interval -1
            }
          '';
        };
        reverseProxies = {
          "rss.peterrice.xyz" = "ruan.ygg.pvsr.dev:21304";
          "comics.peterrice.xyz" = "ruan.ygg.pvsr.dev:19191";
          "weather.peterrice.xyz" = "ruan.ygg.pvsr.dev:15658";
          "calendar.peterrice.xyz" = "ruan.ygg.pvsr.dev:52032";
        };
      };

      services.openssh.listenAddresses = [
        {
          addr = "0.0.0.0";
          port = 18325;
        }
      ];

      networking.firewall.allowedTCPPorts = [ 18325 ];

      virtualisation.vmVariant = {
        services.cloud-init.enable = false;
      };

      system.stateVersion = "24.05";
    };
}
