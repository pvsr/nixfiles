{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "crossbell";

  time.timeZone = "America/New_York";

  users.users.root.openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHwIv6+ZEHCVNmIS1vfUO+bqIP2y3hv3h/AzzmvTQ3HI"];
  services = {
    headscale.enable = true;
    headscale.serverUrl = "https://tailscale.peterrice.xyz";
    headscale.port = 9753;
    headscale.address = "0.0.0.0";

    openssh.enable = true;
    openssh.ports = [18325];
    openssh.passwordAuthentication = false;

    caddy.enable = true;
    caddy.virtualHosts = {
      "peterrice.xyz".extraConfig = ''
        root * /srv
        file_server
      '';
      "rss.peterrice.xyz".extraConfig = "reverse_proxy ruan:8080";
      "calendar.peterrice.xyz".extraConfig = "reverse_proxy ruan:52032";
      "podcasts.peterrice.xyz".extraConfig = "reverse_proxy ruan:5999";
      "tailscale.peterrice.xyz".extraConfig = "reverse_proxy localhost:9753";
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
    18325
  ];

  system.stateVersion = "22.05";
}
