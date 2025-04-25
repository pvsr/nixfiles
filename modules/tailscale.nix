{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.local.tailscale.ip = lib.mkOption {
    readOnly = true;
    default = "100.64.0.${toString config.local.hosts.${config.networking.hostName}.id}";
  };

  config = {
    services.tailscale.enable = true;
    networking.firewall.checkReversePath = "loose";
    systemd.network.wait-online.ignoredInterfaces = [ "tailscale0" ];
    networking.firewall.trustedInterfaces = [ "tailscale0" ];
    boot.kernel.sysctl = {
      "net.ipv4.ip_forward" = true;
      "net.ipv6.conf.all.forwarding" = true;
    };
  };
}
