{ lib, ... }:
{
  flake.modules.nixos.gateway =
    { config, pkgs, ... }:
    let
      cfg = config.local.caddy-gateway;
    in
    {
      options.local.caddy-gateway = {
        virtualHosts = lib.mkOption { default = { }; };
        reverseProxies = lib.mkOption { default = { }; };
        internalProxies = lib.mkOption { default = { }; };
      };

      config.services.caddy = {
        enable = true;
        package = pkgs.caddy.withPlugins {
          plugins = [ "github.com/caddy-dns/cloudflare@v0.2.1" ];
          hash = "sha256-Gsuo+ripJSgKSYOM9/yl6Kt/6BFCA6BuTDvPdteinAI=";
        };
        enableReload = true;
        globalConfig = ''
          admin :40013
          metrics {
            per_host
          }
        '';
        virtualHosts =
          cfg.virtualHosts
          // builtins.mapAttrs (_: dest: { extraConfig = "reverse_proxy ${dest}"; }) cfg.reverseProxies
          // builtins.mapAttrs (_: dest: {
            extraConfig = ''
              reverse_proxy ${dest}
              tls {
                dns cloudflare {env.DNS_API_TOKEN}
                resolvers 1.1.1.1 1.0.0.1
              }
            '';
          }) cfg.internalProxies;
      };

      config.networking.firewall.allowedTCPPorts = [
        80
        443
      ];

      config.networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 40013 ];
    };
}
