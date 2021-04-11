{ config, lib, ... }:
let
  cfg = config.services.transmission;
  # host = config.networking.hostName;
in
{
  age.secrets."transmission-credentials.json" = {
    file = ../secrets/transmission-credentials.json.age;
    owner = "transmission";
    group = "transmission";
  };

  services.transmission = {
    enable = true;
    credentialsFile = config.age.secrets."transmission-credentials.json".path;
    settings = {
      download-dir = "${cfg.home}/downloads";
      #rpc-host-whitelist = host;
      rpc-host-whitelist = "ruan";
      rpc-bind-address = "0.0.0.0";
      rpc-whitelist = "127.0.0.1,192.168.*.*";
    };
  };

  networking.firewall.allowedTCPPorts = [ 9091 ];
}
