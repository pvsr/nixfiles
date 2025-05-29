{
  config,
  lib,
  pkgs,
  ...
}:
let
  hosts = builtins.mapAttrs (
    name: host:
    let
      config = host.nixosConfiguration.config;
    in
    {
      ip = config.local.tailscale.ip;
      nodeExport = config.services.prometheus.exporters.node.enable;
    }
  ) config.local.hosts;
  cfg = config.local.metrics;
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
              { targets = [ "${hosts.ruan.ip}:40013" ]; }
              { targets = [ "${hosts.crossbell.ip}:40013" ]; }
            ];
          }
          {
            job_name = "node";
            static_configs = [
              {
                targets = lib.mapAttrsToList (name: _: "${hosts.${name}.ip}:54247") (
                  lib.filterAttrs (name: _: hosts.${name}.nodeExport) hosts
                );
              }
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
