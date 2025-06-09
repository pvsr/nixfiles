{
  config,
  pkgs,
  lib,
  ...
}:
let
  id = toString config.local.id;
in
{
  options.local.tailscale.ip = lib.mkOption {
    readOnly = true;
    default = if config.services.tailscale.enable then "100.64.0.${id}" else "127.0.0.1";
  };

  config = {
    services.tailscale.enable = lib.mkDefault true;
    networking.firewall.checkReversePath = "loose";
    systemd.network.wait-online.ignoredInterfaces = [ "tailscale0" ];
    networking.firewall.trustedInterfaces = [ "tailscale0" ];
    boot.kernel.sysctl = {
      "net.ipv4.ip_forward" = true;
      "net.ipv6.conf.all.forwarding" = true;
    };
  };
}
