{ config, lib, ... }:
let
  cfg = config.services.transmission;
  # host = config.networking.hostName;
in
{
  services.transmission = {
    enable = true;
    # TODO
    # credentialsFile = ;
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
