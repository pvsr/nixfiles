{ config, pkgs, lib, wg-conf, ... }:
let
  hostname = config.networking.hostName;
  host = wg-conf.${hostname};
  otherHosts = lib.filterAttrs (n: v: n != hostname) wg-conf;
  selectEndpoint = host: (builtins.removeAttrs host [
    "endpointFrom"
    "listenPort"
  ]) //
  lib.optionalAttrs (lib.hasAttrByPath [ "endpointFrom" hostname ] host) {
    endpoint = host.endpointFrom.${hostname};
  };
  peers = map selectEndpoint (lib.attrValues otherHosts);
in
{
  environment.systemPackages = with pkgs; [ wireguard wireguard-tools ];

  networking.firewall.allowedUDPPorts = [ host.listenPort ];

  networking.wireguard.interfaces.wg0 = {
    inherit (host) listenPort;
    inherit peers;
    ips = map (builtins.replaceStrings [ "/32" "/128" ] [ "/24" "/64" ]) host.allowedIPs;
    privateKeyFile = "/etc/ssh/wireguard.key";
  };
}
