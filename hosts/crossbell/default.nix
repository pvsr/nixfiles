{
  config,
  lib,
  inputs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    inputs.srvos.nixosModules.server
    inputs.srvos.nixosModules.hardware-vultr-vm
  ];

  time.timeZone = "America/New_York";

  nix.gc.automatic = true;

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHwIv6+ZEHCVNmIS1vfUO+bqIP2y3hv3h/AzzmvTQ3HI"
  ];
  environment.systemPackages = [ config.services.headscale.package ];

  # override setting from srvos
  programs.vim =
    {
      defaultEditor = false;
    }
    // lib.optionalAttrs (lib.versionAtLeast (lib.versions.majorMinor lib.version) "24.11") {
      enable = false;
    };

  local.caddy-gateway = {
    enable = true;
    virtualHosts = {
      "pvsr.dev" = {
        extraConfig = ''
          root * /srv
          file_server
        '';
      };
      "peterrice.xyz".extraConfig = "redir https://pvsr.dev";
      "podcasts.peterrice.xyz".extraConfig = ''
        reverse_proxy ruan.ts.peterrice.xyz:5999 {
          flush_interval -1
        }
      '';
    };
    reverseProxies = {
      "rss.peterrice.xyz" = "ruan.ts.peterrice.xyz:8080";
      "comics.peterrice.xyz" = "ruan.ts.peterrice.xyz:19191";
      "weather.peterrice.xyz" = "ruan.ts.peterrice.xyz:15658";
      "recipes.peterrice.xyz" = "ruan.ts.peterrice.xyz:36597";
      "calendar.peterrice.xyz" = "ruan.ts.peterrice.xyz:52032";
      "tailscale.peterrice.xyz" = "localhost:9753";
    };
  };

  services = {
    headscale.enable = config.services.tailscale.enable;
    headscale.address = "127.0.0.1";
    headscale.port = 9753;
    headscale.settings = {
      ip_prefixes = [ "100.64.0.0/10" ];
      server_url = "https://tailscale.peterrice.xyz";
      dns.base_domain = "ts.peterrice.xyz";
      dns.magic_dns = true;
      dns.nameservers.global = [
        "1.1.1.1"
        "1.0.0.1"
        "2606:4700:4700::1111"
        "2606:4700:4700::1001"
      ];
      dns.override_local_dns = true;
      dns.extra_records = [
        {
          name = "grafana.peterrice.xyz";
          type = "A";
          value = config.local.hosts.ruan.nixos.config.local.tailscale.ip;
        }
      ];
      policy.path = builtins.toFile "acl.json" (
        builtins.toJSON {
          acls = [
            {
              action = "accept";
              src = [ "*" ];
              dst = [ "*:*" ];
            }
          ];
          ssh = [
            {
              action = "accept";
              src = [ "${config.local.user.name}@" ];
              dst = [ "*" ];
              users = [ config.local.user.name ];
            }
          ];
        }
      );
    };

    openssh.listenAddresses = [
      {
        addr = "0.0.0.0";
        port = 18325;
      }
    ];
  };

  networking.firewall.allowedTCPPorts = [ 18325 ];

  virtualisation.vmVariant = {
    services.cloud-init.enable = false;
  };

  system.stateVersion = "24.05";
}
