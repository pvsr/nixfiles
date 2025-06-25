{ self, ... }:
{
  flake.modules.homeManager.nixos =
    { config, pkgs, ... }:
    {
      imports = [
        self.modules.homeManager.desktop
      ];

      programs.gpg.enable = true;
      programs.gpg.homedir = "${config.xdg.dataHome}/gnupg";
      services.gpg-agent = {
        enable = true;
        defaultCacheTtl = 3 * 60 * 60;
        maxCacheTtl = 8 * 60 * 60;
        pinentry.package = pkgs.pinentry-curses;
      };
    };
}
