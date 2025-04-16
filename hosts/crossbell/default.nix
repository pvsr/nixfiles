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
              src = [ "*" ];
              dst = [ "*" ];
              users = [ config.local.user.name ];
            }
          ];
        }
      );
    };

    openssh.enable = true;
    openssh.ports = [ 18325 ];

    caddy = {
      enable = true;
      enableReload = true;
      virtualHosts = {
        "peterrice.xyz" = {
          serverAliases = [ "pvsr.dev" ];
          extraConfig = ''
            root * /srv
            file_server
          '';
        };
        "rss.peterrice.xyz".extraConfig = "reverse_proxy ruan:8080";
        "comics.peterrice.xyz".extraConfig = "reverse_proxy ruan:19191";
        "weather.peterrice.xyz".extraConfig = "reverse_proxy ruan:15658";
        "recipes.peterrice.xyz".extraConfig = "reverse_proxy ruan:36597";
        "calendar.peterrice.xyz".extraConfig = "reverse_proxy ruan:52032";
        "tailscale.peterrice.xyz".extraConfig = "reverse_proxy localhost:9753";
        "podcasts.peterrice.xyz".extraConfig = ''
          reverse_proxy ruan:5999 {
            flush_interval -1
          }
        '';
      };
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
    18325
  ];

  virtualisation.vmVariant = {
    services.cloud-init.enable = false;
    networking.hostName = "crossbell";
  };

  system.stateVersion = "24.05";
}
