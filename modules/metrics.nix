{ config, lib, ... }:
let
  hosts = config.flake.nixosConfigurations;
in
{
  flake.modules.nixos.core =
    { config, ... }:
    {
      services.prometheus.exporters.node = {
        enable = lib.mkDefault true;
        port = 54247;
        enabledCollectors = [ "systemd" ];
      };
      networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 54247 ];
    };

  flake.modules.nixos.ruan =
    { config, pkgs, ... }:
    let
      mkTargets =
        enabled: port:
        lib.mapAttrsToList (_: host: "${host.config.networking.hostName}:${port}") (
          lib.filterAttrs (_: enabled) hosts
        );
    in
    {
      local.caddy-gateway.internalProxies."grafana.peterrice.xyz" = "localhost:10508";
      environment.persistence.nixos.directories = [
        "/var/lib/grafana"
        "/var/lib/private/victoriametrics"
      ];
      services.victoriametrics = {
        enable = true;
        prometheusConfig = {
          scrape_configs = [
            {
              job_name = "caddy";
              static_configs = [
                { targets = mkTargets (host: host.config.local ? caddy-gateway) "40013"; }
              ];
            }
            {
              job_name = "node";
              static_configs = [
                { targets = mkTargets (host: host.config.services.prometheus.exporters.node.enable) "54247"; }
              ];
            }
          ];
        };
      };
      services.grafana = {
        enable = true;
        declarativePlugins = with pkgs.grafanaPlugins; [
          victoriametrics-metrics-datasource
        ];
        settings = {
          server = {
            http_addr = "127.0.0.1";
            http_port = 10508;
            enable_gzip = true;
          };
          analytics.reporting_enabled = false;
          plugins.allow_loading_unsigned_plugins = "victoriametrics-metrics-datasource";
        };
        provision = {
          enable = true;
          datasources.settings.datasources = [
            {
              name = "VictoriaMetrics";
              type = "victoriametrics-metrics-datasource";
              url = "http://localhost:8428";
            }
          ];
        };
      };
    };
}
