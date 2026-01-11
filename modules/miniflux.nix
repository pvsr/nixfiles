{
  flake.modules.nixos.ruan =
    { config, ... }:
    {
      age.secrets."miniflux-credentials" = {
        file = ../modules/hosts/ruan/secrets/miniflux-credentials.age;
      };

      services.miniflux = {
        enable = true;
        config.LISTEN_ADDR = "[::]:21304";
        adminCredentialsFile = config.age.secrets."miniflux-credentials".path;
      };
      networking.firewall.interfaces.ygg0.allowedTCPPorts = [ 21304 ];
    };
}
