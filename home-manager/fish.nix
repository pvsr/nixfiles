{ config, pkgs, lib, fishPlugins, ... }:
{
  home.packages = with pkgs; [
    fish
    exa
  ];

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
    };
    promptInit = ''
      ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source
    '';
    interactiveShellInit = ''
      set -U fish_key_bindings fish_hybrid_key_bindings
      set -U fzf_fish_custom_keybindings
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
    shellAliases = {
      nvim_nowrite = "nvim '+set noundofile' '+set noswapfile'";
      pass = "EDITOR=nvim_nowrite command pass";
      ls = "exa";
      ll = "exa -lb";
      la = "exa -lba";
      tree = "exa -T";
      bell = "echo \\a";
      mp = "mpc toggle";
      qpm = "qbpm";
      "hoi4" = "steam steam://rungameid/394360";
      "eu4" = "steam steam://rungameid/236850";
      "ck3" = "steam steam://rungameid/1158310";
    };
    plugins = lib.mapAttrsToList (name: src: { inherit name src; }) fishPlugins;
  };

  programs.fzf.enableFishIntegration = false;
}
