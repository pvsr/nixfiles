{ config, lib, ... }:
let
  inherit (config.local) appFont;
in
{
  flake.modules.hjem.core.options.qutebrowser.extraConfig = lib.mkOption {
    type = lib.types.lines;
    default = "";
  };

  flake.modules.hjem.desktop =
    { config, pkgs, ... }:
    {
      packages = [ pkgs.qutebrowser ];
      xdg.config.files."qutebrowser/config.py".text = builtins.concatStringsSep "\n" [
        (builtins.readFile ./config.py)
        ''
          config.set("fonts.default_family", ["${appFont}", "monospace"])
          c.fonts.default_size = "13pt"
          c.fonts.hints = "bold 12pt default_family"
          c.fonts.prompts = "12pt sans_serif"
        ''
        config.qutebrowser.extraConfig
        "config.load_autoconfig()"
      ];
    };
}
