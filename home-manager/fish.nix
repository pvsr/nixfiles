{ config, pkgs, lib, fishPlugins, ... }:
{
  home.shellAliases.fish = "SHELL=${pkgs.fish}/bin/fish command fish";
  programs.fish = {
    enable = true;
    functions = {
      # TODO get playlist position from mpc dummy
      playlist = ''
        set current (ncmpcpp --current-song %t 2> /dev/null)
        and mpc playlist | rg --passthru -F "$current"
        or mpc playlist
      '';
      "90dl" = ''
        set batch $argv[1]
        set season (basename $batch)
        set show_dir (dirname $batch)
        set show_name (basename (realpath $show_dir))
        youtube-dl --cookies ~/downloads/cookies.txt \
          -o "$show_dir/S%(season_number)02d/$show_name.S%(season_number)02d.E%(episode_number)02d.%(title)s.%(ext)s" \
          --download-archive "~/.local/share/youtube-dl/archives/$suffix.$season.archive" \
          --no-overwrites -i -a "$batch"
      '';
      yts = "mpv 'ytdl://ytsearch1:'$argv[1] $argv[2..-1]";
      session = ''
        if set -q argv[1]
          set -gx fish_history $argv[1]
          set data_dir "$HOME/.local/share/z/sessions/$argv[1]"
          mkdir -p $data_dir
          and set -gx Z_DATA "$data_dir/data"
          and touch $Z_DATA
        else
          set -ge fish_history
          set -ge Z_DATA
        end
      '';
      fish_mode_prompt = "";
      fzf_key_bindings = "";
    };
    interactiveShellInit = ''
      ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source
      set -g fish_key_bindings fish_hybrid_key_bindings
      set -g fish_cursor_default block
      set -g fish_cursor_insert line
      set -g fish_cursor_replace_one underscore
      set -g fish_greeting
    '';
    shellAbbrs = {
      suod = "sudo";
      sc = "systemctl";
      ssc = "sudo systemctl";
      scu = "systemctl --user";
      trr = "transmission-remote ruan:9919";
    };
    plugins = lib.mapAttrsToList (name: src: { inherit name src; }) fishPlugins;
  };

  home.packages = with pkgs.fishPlugins; [
    fzf-fish
    pisces
  ];

  programs.fzf.enableFishIntegration = false;
}
