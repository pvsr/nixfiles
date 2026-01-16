{
  local.desktops.ruan =
    { config, ... }:
    {
      networking.firewall.interfaces.ygg0.allowedTCPPorts = [ 5999 ];

      services.podcasts = {
        annexDir = "/run/media/data/annex";
        podcastSubdir = "hosted-podcasts";
        fetch = {
          enable = true;
          user = config.local.user.name;
          group = "users";
          startAt = "0,8,16:0";
        };
        serve = {
          enable = true;
          bind = "[::]:5999";
          timeout = 120;
        };
      };
      environment.persistence.nixos.directories = [ "/var/lib/podcasts" ];
    };
}
