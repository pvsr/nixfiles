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

  services = {
    openssh.enable = true;
    openssh.ports = [18325];
    openssh.permitRootLogin = "no";
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
      "tailscale.peterrice.xyz".extraConfig = "reverse_proxy ruan:9753";
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
    18325
  ];

  system.stateVersion = "22.05";
}
