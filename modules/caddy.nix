{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.local.caddy-gateway;
in
{
  options.local.caddy-gateway = {
    enable = lib.mkEnableOption { };
    virtualHosts = lib.mkOption { default = { }; };
    reverseProxies = lib.mkOption { default = { }; };
  };

  config = lib.mkIf cfg.enable {
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

    networking.firewall.allowedTCPPorts = [
      80
      443
    ];

    networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 40013 ];
  };
}
