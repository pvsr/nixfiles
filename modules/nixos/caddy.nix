{ lib, ... }:
{
  flake.modules.nixos.core =
    { config, pkgs, ... }:
    let
      cfg = config.local.caddy;
      enable = cfg.virtualHosts != { } || cfg.reverseProxies != { };
    in
    {
      options.local.caddy = {
        virtualHosts = lib.mkOption { default = { }; };
        reverseProxies = lib.mkOption { default = { }; };
      };

      config = lib.mkIf enable {
        services.caddy = {
          enable = true;
          enableReload = true;
          globalConfig = ''
            admin :40013
            metrics {
              per_host
            }
          '';
          virtualHosts =
            cfg.virtualHosts
            // builtins.mapAttrs (_: dest: { extraConfig = "reverse_proxy ${dest}"; }) cfg.reverseProxies;
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
