{
  flake.modules.homeManager.desktop =
    { config, lib, ... }:
    {
      programs.niri.settings = {
        input.keyboard = {
          xkb.layout = "us";
          xkb.options = "ctrl:nocaps";
          repeat-rate = 50;
          repeat-delay = 300;
        };
        input.workspace-auto-back-and-forth = true;

        layout = {
          gaps = 14;
          center-focused-column = "never";
          default-column-width = {
            proportion = 0.5;
          };

          focus-ring = {
            enable = false;
            # width = 2;
            # active-color = "#ff5c8f";
            # inactive-color = "#505050";
          };

          border.enable = false;
          shadow.enable = true;
          struts.left = 20;
          struts.right = 20;
        };

        prefer-no-csd = true;
        screenshot-path = "~/pictures/screenshots/screenshot_%Y-%m-%d_%H:%M:%S.png";

        window-rules = [
          {
            geometry-corner-radius = {
              top-left = 12.;
              top-right = 12.;
              bottom-left = 12.;
              bottom-right = 12.;
            };
            clip-to-geometry = true;
          }
          {
            matches = [
              { app-id = "firefox$"; }
              { title = "^Picture-in-Picture$"; }
            ];
            open-floating = true;
          }
        ];
      };
    };
}
