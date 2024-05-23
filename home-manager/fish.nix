{
  config,
  pkgs,
  lib,
  ...
}: let
  zoxideFile = pkgs.runCommandLocal "zoxide.fish" {nativeBuildInputs = [pkgs.zoxide];} "zoxide init fish > $out";
in {
  home.shellAliases.fish = "SHELL=${pkgs.fish}/bin/fish command fish";

  programs.zoxide.enableFishIntegration = false;

  programs.eza.enable = true;
  programs.eza.git = true;

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      ${lib.optionalString config.programs.zoxide.enable "source ${zoxideFile}"}
      set -g fish_key_bindings fish_hybrid_key_bindings
      set -g fish_cursor_default block
      set -g fish_cursor_insert line
      set -g fish_cursor_replace_one underscore
      set -g fish_greeting
      __git.init
    '';
    functions = {
      yts = "mpv 'ytdl://ytsearch1:'$argv[1] $argv[2..-1]";
      uts = "umpv 'ytdl://ytsearch1:'$argv[1] $argv[2..-1]";
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
      fzf_key_bindings = "";
      # TODO remove when default changes in next major release
      fish_user_key_bindings = ''
        bind \cc 'commandline ""'
      '';
      fish_mode_prompt = "";
      fish_prompt_loading_indicator = ''
        echo -n "$argv[1]" | sed -r 's/\x1B\[[0-9;]*[JKmsu]//g' | read -zl uncolored_last_prompt
        echo -n (set_color brblack)"$uncolored_last_prompt"(set_color normal)
      '';
    };
    shellAbbrs = {
      suod = "sudo";
      # TODO only enable when commands are present
      sc = "systemctl";
      ssc = "sudo systemctl";
      scu = "systemctl --user";
      jcl = "journalctl -xe";
      jcb = "journalctl -xb";
      jcf = "journalctl -xf";
      jcu = "journalctl -xeu";
      jcuf = "journalctl -xfu";
      trr = "transmission-remote ruan:9919";
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
    };
  };

  home.packages = with pkgs.fishPlugins; [
    pisces
    fzf-fish
    plugin-git
    async-prompt
    fish-prompt-pvsr
  ];

  # prefer fzf-fish plugin
  programs.fzf.enableFishIntegration = false;
}
