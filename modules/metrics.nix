{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.local.metrics;
in
{
  options.local.metrics = {
    enable = lib.mkEnableOption { };
  };

  config = lib.mkIf cfg.enable {
    local.impermanence.directories = [
      "/var/lib/grafana"
      "/var/lib/private/victoriametrics"
    ];
    services.victoriametrics = {
      enable = true;
      prometheusConfig = {
        scrape_configs =
          [
            {
              job_name = "caddy (crossbell)";
              static_configs = [
                { targets = [ "100.64.0.1:40013" ]; }
              ];
            }
            {
              job_name = "caddy (ruan)";
              static_configs = [
                { targets = [ "100.64.0.3:40013" ]; }
              ];
            }
          ]
          ++ lib.mapAttrsToList
            (name: host: {
              job_name = "node (${name})";
              static_configs = [
                {
                  targets = [ "100.64.0.${toString host.id}:54247" ];
                  labels.type = "node";
                }
              ];
            })
            (
              lib.filterAttrs (
                _: host: host.nixosConfiguration.config.services.prometheus.exporters.node.enable
              ) config.local.hosts
            );
      };
    };
    services.grafana = {
      enable = true;
      declarativePlugins = with pkgs.grafanaPlugins; [
        victoriametrics-metrics-datasource
      ];
      settings = {
        server = {
          http_addr = "100.64.0.3";
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
