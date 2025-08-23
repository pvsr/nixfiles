{ inputs, ... }:
{
  flake.modules.homeManager.core =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      zoxideFile = pkgs.runCommandLocal "zoxide.fish" {
        nativeBuildInputs = [ pkgs.zoxide ];
      } "zoxide init fish > $out";
    in
    {
      home.shell.enableBashIntegration = false;
      home.shellAliases.fish = "SHELL=${pkgs.fish}/bin/fish command fish";

      programs.zoxide.enableFishIntegration = false;

      programs.eza.enable = true;
      programs.eza.git = true;

      programs.fish = {
        enable = true;
        preferAbbrs = true;
        generateCompletions = false;
        interactiveShellInit = ''
          ${lib.optionalString config.programs.zoxide.enable "source ${zoxideFile}"}
          set -g fish_key_bindings fish_hybrid_key_bindings
          bind -M insert ctrl-n down-or-search
          set -g fish_cursor_default block
          set -g fish_cursor_insert line
          set -g fish_cursor_replace_one underscore
          set -g fish_greeting
          __git.init
        '';
        functions = {
          yts = {
            wraps = "mpv";
            body = "mpv 'ytdl://ytsearch1:'$argv[1] $argv[2..-1]";
          };
          uts = {
            wraps = "mpv";
            body = "umpv 'ytdl://ytsearch1:'$argv[1] $argv[2..-1]";
          };
          session = ''
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
        };
        shellAbbrs = {
          # TODO only enable when commands are present
          sc = "systemctl";
          ssc = "sudo systemctl";
          scu = "systemctl --user";
          jc = "journalctl";
          jce = "journalctl -e";
          jcf = "journalctl -f";
          jcu = "journalctl -u";
          jcb = "journalctl -b";
          jcm = "sudo journalctl -M";
          gcp = "git commit -p";
          "gcp!" = "git commit -p --amend";
          "gcpn!" = "git commit -p --no-edit --amend";
          gcpm = "git commit -p -m";
          gan = "git annex";
          mshuf = "mpv --no-video --shuffle ~/annex/music";
          pmpv = "umpv (wl-paste)";
          ls = "eza";
          l = "eza -l";
          ll = "eza -l";
          la = "eza -la";
          e = "eza -l";
          ea = "eza -la";
          er = "eza -ls modified";
          et = "eza -T";
          nn = {
            position = "anywhere";
            expansion = "--log-format internal-json -v 2&| nom --json";
          };
          ".c/" = {
            position = "anywhere";
            setCursor = true;
            expansion = "$XDG_CONFIG_HOME/%";
          };
        };
      };

      home.packages = with pkgs.fishPlugins; [
        plugin-git
        (buildFishPlugin {
          pname = "fzf-fish";
          src = inputs.fzf-fish;
          version = inputs.fzf-fish.shortRev;
        })
        (buildFishPlugin {
          pname = "fish-prompt-pvsr";
          src = inputs.fish-prompt-pvsr;
          version = inputs.fish-prompt-pvsr.shortRev;
        })
      ];

      # prefer fzf-fish plugin
      programs.fzf.enableFishIntegration = false;
    };
}
