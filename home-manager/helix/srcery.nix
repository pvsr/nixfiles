{
  programs.helix.themes.srcery = {
    inherits = "gruvbox";
    "ui.selection".bg = "bg2";
    "ui.cursor.primary" = {
      bg = "fg4";
      fg = "bg1";
    };
    "ui.cursor.match".bg = "bg3";
    "ui.virtual.jump-label" = {
      bg = "bg2";
      modifiers = [ "bold" ];
    };
    "ui.bufferline.active".bg = "bg3";
    palette = {
      bg0 = "#1c1b19";
      bg1 = "#262626";
      bg2 = "#303030";
      bg3 = "#3a3a3a";
      bg4 = "#444444";

      fg0 = "#fce8c3";
      fg1 = "#fce8c3";
      fg2 = "#baa67f";
      fg3 = "#baa67f";
      fg4 = "#918175";

      gray0 = "#918175";
      gray1 = "#585858";

      red0 = "#ef2f27";
      red1 = "#f75341";
      green0 = "#519f50";
      green1 = "#98bc37";
      yellow0 = "#fbb829";
      yellow1 = "#fed06e";
      blue0 = "#2c78bf";
      blue1 = "#68a8e4";
      purple0 = "#e02c6d";
      purple1 = "#ff5c8f";
      aqua0 = "#0aaeb3";
      aqua1 = "#2be4d0";
      orange0 = "#ff5f00";
      orange1 = "#ff8700";
    };
  };

  programs.helix.settings.theme = "srcery";
}
