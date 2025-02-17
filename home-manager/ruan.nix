{ self, ... }:
{
  flake.modules.homeManager.ruan =
    { pkgs, ... }:
    {
      imports = [
        self.modules.homeManager.desktop
        self.modules.homeManager.firefox
      ];

      programs.niri.settings.outputs."HDMI-A-3".scale = 2.0;
    };
}
