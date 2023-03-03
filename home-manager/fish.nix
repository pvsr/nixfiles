{
  config,
  pkgs,
  lib,
  fishPlugins,
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
      yts = "mpv 'ytdl://ytsearch1:'$argv[1] $argv[2..-1]";
      session = ''
        if set -q argv[1]
          set -gx fish_history $argv[1]
          set data_dir "$HOME/.local/share/z/sessions/$argv[1]"
          mkdir -p $data_dir
          and set -gx Z_DATA "$data_dir/data"
          and touch $Z_DATA
          z > /dev/null
          or pushd .
        else
          set -ge fish_history
          set -ge Z_DATA
          popd 2> /dev/null
        end
      '';
      fish_mode_prompt = "";
      fzf_key_bindings = "";
      alejandra = "command alejandra $argv &| rg --passthru -U --replace '' '\n*[👏👉⭐].*'";
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
      pmpv = "mpv (wl-paste)";
    };
    plugins = lib.mapAttrsToList (name: src: {inherit name src;}) fishPlugins;
  };

  home.packages = with pkgs.fishPlugins; [
    fzf-fish
    pisces
  ];

  # prefer fzf-fish plugin
  programs.fzf.enableFishIntegration = false;
}
