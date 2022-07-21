{
  pkgs,
  config,
  lib,
  ...
}: let
  nginxUser = config.services.nginx.user;
  nginxGroup = config.services.nginx.group;
  podcastPath = "/media/data/annex/hosted-podcasts";
in {
  networking.firewall.allowedTCPPorts = [5998 5999];

  services.podcasts = {
    podcastDir = podcastPath;
    dataDir = "/media/nixos/podcasts";
    fetch = {
      enable = true;
      user = "peter";
      group = "users";
      startAt = "5,17:0";
    };
    serve.enable = true;
  };

  age.secrets."nginx-podcasts.htpasswd" = {
    file = ./secrets/nginx-podcasts.htpasswd.age;
    owner = nginxUser;
    group = nginxGroup;
  };
  services.nginx = {
    enable = true;

    virtualHosts.podcasts = {
      serverName = "podcasts.peterrice.xyz";
      listen = [
        {
          addr = "0.0.0.0";
          port = 5999;
        }
      ];
      basicAuthFile = config.age.secrets."nginx-podcasts.htpasswd".path;
      locations."/" = {
        root = podcastPath;
      };
    };
  };

  users.users.${nginxUser}.extraGroups = [
    "users"
  ];

  systemd.services.nginx.serviceConfig.ProtectHome = "tmpfs";
  systemd.services.nginx.serviceConfig.BindReadOnlyPaths = podcastPath;
}
