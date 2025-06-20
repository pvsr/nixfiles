{ self, ... }:
{
  flake.modules.homeManager.grancel =
    { pkgs, ... }:
    {
      imports = [
        self.modules.homeManager.nixos
        self.modules.homeManager.firefox
      ];

      home.packages = with pkgs; [
        (prismlauncher.override {
          jdks = [
            jdk
          ];
        })
        sptlrx
      ];

      services.spotifyd = {
        enable = true;
        package = pkgs.spotifyd.override { withMpris = true; };
        settings.global = {
          backend = "pulseaudio";
          bitrate = 160;
          initial_volume = "100";
        };
      };

      services.mpris-proxy.enable = true;
    };
}
