{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [./srcery.nix];

  programs.fish.shellAbbrs.nvim = "hx";

  # TODO fix this
  home.sessionVariables = lib.mkForce {
    EDITOR = "hx";
    VISUAL = "hx";
  };

  programs.git.extraConfig.core.editor = "hx";

  programs.helix = {
    enable = true;
    settings = {
      theme = "srcery";
      editor = {
        line-number = "relative";
        scrolloff = 2;
        rulers = [80];
        color-modes = true;
        whitespace.render.tab = "all";
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
      };
    };
  };
}
