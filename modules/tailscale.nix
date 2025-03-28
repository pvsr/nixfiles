{
  config,
  pkgs,
  lib,
  ...
}:
{
  services.tailscale.enable = true;
  networking.firewall.checkReversePath = "loose";
  systemd.network.wait-online.ignoredInterfaces = [ "tailscale0" ];
  networking.firewall.trustedInterfaces = [ "tailscale0" ];
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = true;
    "net.ipv6.conf.all.forwarding" = true;
  };
}
