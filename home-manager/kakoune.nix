{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [];

  programs.kakoune = {
    enable = true;
    config = {
      colorScheme = "srcery";
      indentWidth = 2;
      tabStop = 2;

      numberLines = {
        enable = true;
        relative = true;
        highlightCursor = true;
      };
      # showWhitespace.enable = true;
      wrapLines.enable = true;
      ui = {
        enableMouse = true;
        assistant = "none";
      };

      keyMappings = [
        {
          key = "/";
          mode = "normal";
          effect = "/(?i)";
        }
      ];
    };
  };

  #programs.fish.shellAliases.nvim = "kak";
}
