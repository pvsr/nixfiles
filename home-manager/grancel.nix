{ self, ... }:
{
  flake.modules.homeManager.grancel =
    { config, pkgs, ... }:
    {
      imports = [
        self.modules.homeManager.desktop
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

      programs.niri.settings.outputs."HDMI-A-2".variable-refresh-rate = true;

      programs.password-store.enable = true;
      programs.gpg.enable = true;
      programs.gpg.homedir = "${config.xdg.dataHome}/gnupg";
      services.gpg-agent = {
        enable = true;
        defaultCacheTtl = 3 * 60 * 60;
        maxCacheTtl = 8 * 60 * 60;
        pinentry.package = pkgs.pinentry-curses;
      };

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
