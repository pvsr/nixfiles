{ lib, ... }:
let
  settings = {
    theme.dark = "srcery";
    theme.light = "flexoki_light";
    editor = {
      line-number = "relative";
      scrolloff = 2;
      rulers = [ 80 ];
      color-modes = true;
      rainbow-brackets = true;
      bufferline = "multiple";
      soft-wrap.enable = true;
      smart-tab.supersede-menu = true;
      whitespace.render.tab = "all";
      whitespace.render.newline = "all";
      cursor-shape = {
        insert = "bar";
        normal = "block";
        select = "underline";
      };
      lsp.display-inlay-hints = true;
      end-of-line-diagnostics = "hint";
      inline-diagnostics.cursor-line = "hint";
    };
    keys.insert = {
      C-p = "move_line_up";
      C-n = "move_line_down";
      C-f = "move_char_right";
      C-b = "move_char_left";
      C-a = "goto_first_nonwhitespace";
      C-e = "goto_line_end_newline";
      C-c = "toggle_comments";
      C-t = "indent";
      C-g = "unindent";
      C-backspace = "delete_word_backward";
    };
    keys.normal.minus = "file_explorer_in_current_buffer_directory";
  };
  srcery = {
    inherits = "gruvbox";
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
in
{
  flake.modules.hjem.core =
    { config, pkgs, ... }:
    let
      cfg = config.helix;
      toml = pkgs.formats.toml { };
      mkToml = path: value: {
        generator = toml.generate path;
        inherit value;
      };
    in
    {
      options.helix.languages = lib.mkOption {
        type = toml.type;
        default = { };
      };

      config.packages = [ pkgs.helix ];
      config.xdg.config.files = builtins.mapAttrs mkToml ({
        "helix/config.toml" = settings;
        "helix/languages.toml" = cfg.languages;
        "helix/themes/srcery.toml" = srcery;
      });
      config.environment.sessionVariables = {
        EDITOR = "hx";
        VISUAL = "hx";
      };
    };
}
