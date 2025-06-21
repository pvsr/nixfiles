{ config, ... }:
{
  flake.modules.homeManager.desktop.programs.qutebrowser = {
    enable = true;
    loadAutoconfig = true;
    aliases = {
      q = "quit";
      w = "session-save";
      wq = "quit --save";
      x = "quit --save";
      h = "help";
    };

    keyBindings =
      let
        qutePass = builtins.concatStringsSep " " [
          "qute-pass --username-target secret"
          "--username-pattern '(?:username|email): (.+)'"
          "--dmenu-invocation 'fuzzel --dmenu'"
        ];
      in
      {
        normal = {
          "ge" = "scroll-to-perc";
          ",d" = "hint all delete";
          ",r" = "cmd-set-text :open {url:domain}/";
          ",R" = "cmd-set-text :open -t {url:domain}/";
          "xP" = "open -b -- {primary}";
          "xp" = "open -b -- {clipboard}";
          "pw" = "open https://en.wikipedia.org/wiki/Special:Search?search={primary}";
          "Pw" = "open -t https://en.wikipedia.org/wiki/Special:Search?search={primary}";
          "PW" = "open -b https://en.wikipedia.org/wiki/Special:Search?search={primary}";
          ";x" = "hint links spawn -dv umpv --profile=no-term {hint-url}";
          ";X" = "hint links spawn -dv mpv --profile=no-term {hint-url}";
          "xx" = "spawn -dv umpv --profile=no-term {url}";
          "xX" = "spawn -dv mpv --profile=no-term {url}";

          "<Ctrl+e>" = "cmd-run-with-count 2 scroll down";
          "<Ctrl+y>" = "cmd-run-with-count 2 scroll up";
          "zl" = "spawn --userscript ${qutePass}";
          "zul" = "spawn --userscript ${qutePass} --username-only";
          "zpl" = "spawn --userscript ${qutePass} --password-only";
        };
        command = {
          "<Ctrl-w>" = "rl-rubout ' /'";
        };
        prompt = {
          "<Ctrl-w>" = "rl-rubout ' /'";
        };
      };

    settings = {
      confirm_quit = [ "downloads" ];

      new_instance_open_target = "tab-silent";
      new_instance_open_target_window = "last-focused";

      window.hide_decoration = false;

      editor.command = [
        "ghostty"
        "-e"
        "hx"
        "{file}:{line}:{column0}"
      ];

      fileselect = {
        handler = "external";
        single_file.command = [
          "ghostty"
          "-e"
          "ranger"
          "--choosefile={}"
        ];
        multiple_files.command = [
          "ghostty"
          "-e"
          "ranger"
          "--choosefiles={}"
        ];
        folder.command = [
          "ghostty"
          "-e"
          "ranger"
          "--choosedir={}"
        ];
      };

      auto_save.session = true;

      content.autoplay = false;
      content.pdfjs = true;

      completion = {
        shrink = true;
        scrollbar.width = 0;
        scrollbar.padding = 0;
        open_categories = [
          "quickmarks"
          "bookmarks"
          "history"
          "filesystem"
        ];
      };

      hints.auto_follow = "always";
      hints.mode = "letter";

      tabs = {
        background = true;
        favicons.scale = 0.9;
        last_close = "close";
        mode_on_change = "restore";
        show = "multiple";
        indicator.width = 0;
        "padding['bottom']" = 4;
        "padding['left']" = 3;
        "padding['right']" = 3;
        "padding['top']" = 4;
      };

      url.open_base_url = true;

      fonts = {
        default_family = [
          config.local.appFont
          "monospace"
        ];
        default_size = "14pt";

        hints = "bold 13pt default_family";
        prompts = "13pt sans_serif";
      };
    };

    # TODO move to nix
    extraConfig = builtins.readFile ./colors.py;
  };
}
