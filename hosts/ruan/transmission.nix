{ config, pkgs, ... }:
let
  cfg = config.services.transmission;
in
{
  age.secrets."transmission-credentials.json" = {
    file = ./secrets/transmission-credentials.json.age;
    owner = "transmission";
    group = "transmission";
  };

  services.transmission = {
    enable = true;
    openPeerPorts = true;
    openRPCPort = true;
    credentialsFile = config.age.secrets."transmission-credentials.json".path;
    settings = {
      download-dir = "${cfg.home}/downloads";
      peer-port-random-on-start = true;
      peer-port-random-low = 65150;
      peer-port-random-high = 65160;
      rpc-port = 9919;
      rpc-host-whitelist = "ruan,ruan.peter.ts.peterrice.xyz";
      rpc-bind-address = "100.64.0.3";
      rpc-whitelist-enabled = false;
    };
  };
}
