{
  flake.modules.homeManager.core =
    { pkgs, ... }:
    {
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
            lsp = {
              display-inlay-hints = true;
            };
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
      };
    };
}
