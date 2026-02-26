{ lib, ... }:
{
  flake.modules.nixos.core =
    { config, pkgs, ... }:
    let
      cfg = config.local.caddy;
      enable = cfg.virtualHosts != { } || cfg.reverseProxies != { } || cfg.internalProxies != { };
    in
    {
      options.local.caddy = {
        virtualHosts = lib.mkOption { default = { }; };
        reverseProxies = lib.mkOption { default = { }; };
        internalProxies = lib.mkOption { default = { }; };
      };

      config = lib.mkIf enable {
        services.caddy = {
          enable = true;
          package = pkgs.caddy.withPlugins {
            # TODO replace with DNS-PERSIST once supported https://github.com/caddyserver/caddy/issues/7495
            plugins = [ "github.com/caddy-dns/cloudflare@v0.2.1" ];
            hash = "sha256-hZKTEzevrabjgZCCcoRKlqUfdDIUr89KEFJ84kyFxeg=";
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
                  resolvers 185.71.138.138
                }
              '';
            }) cfg.internalProxies;
        };

        environment.persistence.nixos.directories = [ "/var/lib/caddy" ];

        networking.firewall.allowedTCPPorts = [
          80
          443
        ];
        networking.firewall.interfaces.ygg0.allowedTCPPorts = [ 40013 ];
      };
    };
}
