{
  config,
  pkgs,
  lib,
  ...
}: {
  xdg.configFile."helix/themes/srcery.toml".text = let
    gruvbox = builtins.readFile "${pkgs.helix}/lib/runtime/themes/gruvbox.toml";
    gruvboxColors = [
      "#282828"
      "#3c3836"
      "#504945"
      "#665c54"
      "#7c6f64"

      "#fbf1c7"
      "#ebdbb2"
      "#d5c4a1"
      "#bdae93"
      "#a89984"

      "#a89984"
      "#928374"

      "#cc241d"
      "#fb4934"
      "#98971a"
      "#b8bb26"
      "#d79921"
      "#fabd2f"
      "#458588"
      "#83a598"
      "#b16286"
      "#d3869b"
      "#689d6a"
      "#8ec07c"
      "#d65d0e"
      "#fe8019"
    ];
    srceryColors = [
      "#1c1b19"
      "#262626"
      "#303030"
      "#3a3a3a"
      "#444444"

      "#fce8c3"
      "#fce8c3"
      "#baa67f"
      "#baa67f"
      "#918175"

      "#918175"
      "#585858"

      "#ef2f27"
      "#f75341"
      "#519f50"
      "#98bc37"
      "#fbb829"
      "#fed06e"
      "#2c78bf"
      "#68a8e4"
      "#e02c6d"
      "#ff5c8f"
      "#0aaeb3"
      "#2be4d0"
      "#ff5f00"
      "#ff8700"
    ];
  in
    builtins.replaceStrings gruvboxColors srceryColors gruvbox;

  programs.helix.settings.theme = "srcery";
}
