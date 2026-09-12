{ lib, ... }:
let
  settings = {
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
      options.helix.settings = lib.mkOption {
        type = toml.type;
        default = { };
      };
      options.helix.languages = lib.mkOption {
        type = toml.type;
        default = { };
      };

      config.helix.settings = settings;

      config.packages = [ pkgs.helix ];
      config.xdg.config.files = builtins.mapAttrs mkToml ({
        "helix/config.toml" = cfg.settings;
        "helix/languages.toml" = cfg.languages;
      });
      config.environment.sessionVariables = {
        EDITOR = "hx";
        VISUAL = "hx";
      };
    };
}
