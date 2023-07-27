{
  config,
  pkgs,
  lib,
  ...
}: {
  home.shellAliases.fish = "SHELL=${pkgs.fish}/bin/fish command fish";
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source
      set -g fish_key_bindings fish_hybrid_key_bindings
      set -g fish_cursor_default block
      set -g fish_cursor_insert line
      set -g fish_cursor_replace_one underscore
      set -g fish_greeting
    '';
    functions = {
      yts = "umpv 'ytdl://ytsearch1:'$argv[1] $argv[2..-1]";
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
