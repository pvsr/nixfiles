{ ... }:
{
  imports = [ ./srcery.nix ];

  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
      theme = "srcery";
      editor = {
        line-number = "relative";
        scrolloff = 2;
        rulers = [ 80 ];
        color-modes = true;
        bufferline = "multiple";
        smart-tab.supersede-menu = true;
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
      };
      keys.normal.minus = "file_picker_in_current_buffer_directory";
    };
    languages = {
      language = [
        {
          name = "python";
          auto-format = true;
        }
        {
          name = "nix";
          formatter = {
            command = "nixfmt";
          };
          auto-format = true;
        }
      ];
    };
  };
}
