{
  config,
  lib,
  pkgs,
  hosts,
  ...
}:
let
  cfg = config.local.metrics;
  mkTargets =
    enabled: port:
    lib.mapAttrsToList (_: host: "${host.nixos.config.networking.hostName}:${port}") (
      lib.filterAttrs (_: enabled) hosts
    );
in
{
  options.local.metrics = {
    enable = lib.mkEnableOption { };
    grafana = {
      address = lib.mkOption { type = lib.types.str; };
      port = lib.mkOption { type = lib.types.int; };
    };
  };

  config = lib.mkIf cfg.enable {
    local.impermanence.directories = [
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
              { targets = mkTargets (host: host.nixos.config.local.caddy-gateway.enable) "40013"; }
            ];
          }
          {
            job_name = "node";
            static_configs = [
              { targets = mkTargets (host: host.nixos.config.services.prometheus.exporters.node.enable) "54247"; }
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
          http_addr = cfg.grafana.address;
          http_port = cfg.grafana.port;
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
