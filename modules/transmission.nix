{ config, lib, ... }:
let
  inherit (config.services.qbittorrent) port;
  inherit (lib) mkAfter;
in
{
  services.transmission = {
    enable = true;
    # TODO
    # credentialsFile = ;
    settings = {
      rpc-host-whitelist = "ruan";
      rpc-whitelist = "127.0.0.1,192.168.*.*";
      #script-torrent-done-enabled = false;
    };
  };

  #networking.firewall.allowedTCPPorts = [ 9091 ];
}
