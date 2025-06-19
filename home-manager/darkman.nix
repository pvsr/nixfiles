{
  flake.modules.homeManager.desktop =
    { pkgs, ... }:
    let
      scripts = mode: {
        niri = ''
          export NIRI_SOCKET=$(echo /run/user/$(id -u)/niri.*.sock)
          niri msg action do-screen-transition
        '';
        gtk = ''
          ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/color-scheme "'prefer-${mode}'"
        '';
      };
    in
    {
      services.darkman = {
        enable = true;
        settings = {
          lat = 42.4;
          lng = -71.1;
        };
        lightModeScripts = scripts "light";
        darkModeScripts = scripts "dark";
      };
    };
}
