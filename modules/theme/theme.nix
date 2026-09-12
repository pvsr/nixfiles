{ inputs, ... }:
let
  darkVariant = "winter";
  darkTheme = "evergarden-${darkVariant}";
  accent = "pink";
in
{
  flake.modules.nixos.base.imports = [ inputs.evergarden.nixosModules.default ];

  flake.modules.hjem.core =
    { config, pkgs, ... }:
    let
      themePkgs = inputs.evergarden.packages.${pkgs.stdenv.hostPlatform.system};
    in
    {
      helix.settings.theme.light = "flexoki_light";
      helix.settings.theme.dark = darkTheme;
      xdg.config.files."helix/themes/${darkTheme}.toml".source =
        "${themePkgs.helix}/evergarden_${darkVariant}_${accent}.toml";

      ghostty.extraConfig = "theme = light:Flexoki Light,dark:${darkTheme}";
      xdg.config.files."ghostty/themes/${darkTheme}".source =
        "${themePkgs.ghostty}/${darkTheme}-${accent}.yml";

      xdg.config.files."fish/themes/evergarden.theme".text = builtins.concatStringsSep "\n" [
        (builtins.readFile "${themePkgs.fish}/${darkTheme}.theme")
        "[light]"
        (builtins.readFile ./fish/magenta.theme)
      ];

      xdg.config.files."bat/config".text = "--theme-dark=${darkTheme}";
      xdg.config.files."bat/themes/${darkTheme}.tmTheme".source = "${themePkgs.bat}/${darkTheme}.tmTheme";

      qutebrowser.extraConfig = # python
        ''
          import importlib.util
          import sys

          spec = importlib.util.spec_from_file_location("evergarden", "${inputs.evergarden-qutebrowser}/__init__.py")
          sys.modules["evergarden"] = evergarden = importlib.util.module_from_spec(spec)
          spec.loader.exec_module(evergarden)

          evergarden.setup(c, "winter")
        '';

      xdg.config.files."gtk-3.0/gtk.css".text = ''
        @import url("${themePkgs.adwaita}/${darkTheme}-${accent}.css");
      '';
      xdg.config.files."gtk-4.0/gtk.css".text = ''
        @import url("${themePkgs.adwaita}/${darkTheme}-${accent}.css");
        @import url("${themePkgs.adwaita}/gtk4.css");
      '';
    };

  # https://codeberg.org/evergarden/termux/src/branch/main/termux.tera
  flake.modules.nixOnDroid.base.terminal.colors = with inputs.evergarden.lib.palette.${darkVariant}; {
    background = base;
    foreground = text;

    color0 = surface1;
    color1 = red;
    color2 = green;
    color3 = yellow;
    color4 = blue;
    color5 = pink;
    color6 = skye;
    color7 = subtext0;
    color8 = overlay1;
    color9 = red;
    color10 = green;
    color11 = yellow;
    color12 = blue;
    color13 = pink;
    color14 = skye;
    color15 = subtext1;
  };
}
