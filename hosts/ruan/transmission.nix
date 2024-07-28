{
  config,
  lib,
  ...
}: let
  cfg = config.services.transmission;
  # host = config.networking.hostName;
in {
  age.secrets."transmission-credentials.json" = {
    file = ./secrets/transmission-credentials.json.age;
    owner = "transmission";
    group = "transmission";
  };

  services.transmission = {
    enable = true;
    credentialsFile = config.age.secrets."transmission-credentials.json".path;
    settings = {
      download-dir = "${cfg.home}/downloads";
      peer-port = 51555;
      rpc-port = 9919;
      rpc-bind-address = "0.0.0.0";
      rpc-whitelist = "127.0.0.1,192.168.*.*,100.64.0.1,100.64.0.2";
    };
  };

  networking.firewall.allowedTCPPorts = [9919 51555];
}
