{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [./srcery.nix];

  home.sessionVariables = {
    EDITOR = "hx";
    VISUAL = "hx";
  };

  programs.git.extraConfig.core.editor = "hx";

  programs.helix = {
    enable = true;
    # TODO 23.11
    # defaultEditor = true;
    settings = {
      theme = "srcery";
      editor = {
        line-number = "relative";
        scrolloff = 2;
        rulers = [80];
        color-modes = true;
        bufferline = "multiple";
        whitespace.render.tab = "all";
        whitespace.render.newline = "all";
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        lsp = {
          display-inlay-hints = true;
        };
      };
      keys.insert = {
        "C-l" = "move_char_right";
        "C-space" = ["match_brackets" "move_char_right"];
      };
    };
  };
}
