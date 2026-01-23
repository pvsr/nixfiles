{ inputs, lib, ... }:
{
  flake.modules.nixos.core =
    { pkgs, ... }:
    {
      programs.fish.enable = true;
      programs.fish.useBabelfish = true;
      users.defaultUserShell = pkgs.fish;
    };

  flake.modules.hjem.core =
    { config, pkgs, ... }:
    let
      cfg = config.fish;
      writeFish =
        name: content:
        pkgs.runCommandLocal name
          {
            inherit content;
            passAsFile = [ "content" ];
          }
          ''
            ${pkgs.fish}/bin/fish --no-config --no-execute "$contentPath"
            ${pkgs.fish}/bin/fish_indent < "$contentPath" > $out 2> /dev/null
          '';
      mkFunction = name: text: {
        name = "fish/functions/${name}.fish";
        value.source = writeFish "${name}.fish" ''
          function ${name}
            ${text}
          end
        '';
      };
      mkWrapper = wraps: name: text: {
        name = "fish/functions/${name}.fish";
        value.source = writeFish "${name}.fish" ''
          function ${name} --wraps='${wraps}'
            ${text}
          end
        '';
      };
    in
    {
      options.fish = with lib.types; {
        interactiveShellInit = lib.mkOption {
          type = lines;
          default = "";
        };
        functions = lib.mkOption {
          type = attrsOf str;
          default = { };
        };
        wrappers = lib.mkOption {
          type = attrsOf (attrsOf str);
          default = { };
        };
      };

      config.packages = with pkgs; [
        fish
        (fishPlugins.buildFishPlugin {
          pname = "fish-prompt-pvsr";
          src = inputs.fish-prompt-pvsr;
          version = inputs.fish-prompt-pvsr.shortRev;
        })
      ];

      config.xdg.config.files = {
        "fish/conf.d/env.fish".text = lib.concatMapAttrsStringSep "\n" (
          name: value: "set -gx ${lib.escapeShellArg name} ${toString value}"
        ) config.environment.sessionVariables;
        "fish/conf.d/zoxide.fish".source = pkgs.runCommandLocal "zoxide.fish" { } ''
          echo 'status is-interactive; or exit' > $out
          ${pkgs.zoxide}/bin/zoxide init fish >> $out
        '';
        "fish/themes/magenta.theme".source = ./magenta.theme;
        "fish/config.fish".source = writeFish "config.fish" ''
          status is-interactive; or exit
          set -g fish_greeting
          set -g fish_key_bindings fish_hybrid_key_bindings
          bind -M insert ctrl-n down-or-search
          set -g fish_cursor_default block
          set -g fish_cursor_insert line
          set -g fish_cursor_replace_one underscore

          abbr -a --position anywhere -- \
            nn '--log-format internal-json -v 2&| nom --json'
          abbr -a --position anywhere --set-cursor -- \
            .c/ '$XDG_CONFIG_HOME/%'

          abbr -a sc  'systemctl'
          abbr -a ssc 'sudo systemctl'
          abbr -a scu 'systemctl --user'
          abbr -a jc  'journalctl'
          abbr -a jce 'journalctl -e'
          abbr -a jcf 'journalctl -f'
          abbr -a jcu 'journalctl -u'
          abbr -a jcm 'sudo journalctl -M'

          ${cfg.interactiveShellInit}
        '';
      }
      // lib.mapAttrs' mkFunction {
        session = # fish
          ''
              if set -q argv[1]
              set -gx fish_history $argv[1]
              set data_dir "$HOME/.local/share/zoxide/sessions/$argv[1]"
              mkdir -p $data_dir
              and set -gx _ZO_DATA_DIR "$data_dir"
              pushd (zoxide query 2> /dev/null; or echo .)
            else
              set -ge fish_history
              set -ge _ZO_DATA
              popd 2> /dev/null
            end
          '';
        fish_mode_prompt = "";
      }
      // lib.mapAttrs' mkFunction cfg.functions
      // lib.concatMapAttrs (wrapped: lib.mapAttrs' (mkWrapper wrapped)) cfg.wrappers;
    };
}
