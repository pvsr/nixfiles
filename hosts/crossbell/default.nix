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

  nix.gc.automatic = true;

  users.users.root.openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHwIv6+ZEHCVNmIS1vfUO+bqIP2y3hv3h/AzzmvTQ3HI"];
  environment.systemPackages = [config.services.headscale.package];
  services = {
    headscale.enable = true;
    headscale.address = "127.0.0.1";
    headscale.port = 9753;
    headscale.settings = {
      ip_prefixes = ["100.64.0.0/10"];
      server_url = "https://tailscale.peterrice.xyz";
      dns_config.base_domain = "ts.peterrice.xyz";
      dns_config.magic_dns = true;
      dns_config.nameservers = ["1.1.1.1" "1.0.0.1" "2606:4700:4700::1111" "2606:4700:4700::1001"];
      dns_config.override_local_dns = true;
    };

    openssh.enable = true;
    openssh.ports = [18325];
    openssh.settings.PasswordAuthentication = false;

    caddy.enable = true;
    caddy.virtualHosts = {
      "peterrice.xyz".extraConfig = ''
        root * /srv
        file_server
      '';
      "rss.peterrice.xyz".extraConfig = "reverse_proxy ruan:8080";
      "comics.peterrice.xyz".extraConfig = "reverse_proxy ruan:19191";
      "weather.peterrice.xyz".extraConfig = "reverse_proxy ruan:15658";
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

  system.stateVersion = "23.11";
}
