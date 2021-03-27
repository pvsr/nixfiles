{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    fish
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
      set -g fish_key_bindings fish_hybrid_key_bindings
      set -g fish_cursor_default block
      set -g fish_cursor_insert line
      set -g fish_cursor_replace_one underscore
    '';
    plugins = [
      {
        name = "fish-prompt-pvsr";
        src = pkgs.fetchFromGitHub {
          owner = "pvsr";
          repo = "fish-prompt-pvsr";
          rev = "0f46ccaba0d7ebe54471218d6ee1de5124ca5d6d";
          sha256 = "0pvw2yzdn83hll1vb2yvhnzhwwq5972nvv007s9n2vn2x2icm814";
        };
      }
      {
        name = "z";
        src = pkgs.fetchFromGitHub {
          owner = "jethrokuan";
          repo = "z";
          rev = "ddeb28a7b6a1f0ec6dae40c636e5ca4908ad160a";
          sha256 = "0c5i7sdrsp0q3vbziqzdyqn4fmp235ax4mn4zslrswvn8g3fvdyh";
        };
      }
      {
        name = "fzf";
        src = pkgs.fetchFromGitHub {
          owner = "jethrokuan";
          repo = "fzf";
          rev = "6e74bbf18a39b8597799041fbc0aab7ae55f2f80";
          sha256 = "0ypbdfjyv8kgmjvczwb9bx10sp7jd593sd0xadpq1hc8cxm5vsih";
        };
      }
      {
        name = "plugin-git";
        src = pkgs.fetchFromGitHub {
          owner = "jhillyerd";
          repo = "plugin-git";
          rev = "18d8369132bdc349afc9ffc6702098dc8deaaa96";
          sha256 = "10pscjyv7ypbbfa9j2n3r1p8fm5vg86lpdvs4ndj0dh23pazsfhz";
        };
      }
    ];
    shellAbbrs = {
      suod = "sudo";
    };
    shellAliases = {
      nvim_nowrite = "nvim '+set noundofile' '+set noswapfile'";
      pass = "EDITOR=nvim_nowrite command pass";
      ls = "${pkgs.exa}/bin/exa";
      ll = "${pkgs.exa}/bin/exa -l";
      la = "${pkgs.exa}/bin/exa -la";
      tree = "${pkgs.exa}/bin/exa -T";
      bell = "echo \\a";
      mp = "mpc toggle";
      "hoi4" = "steam steam://rungameid/394360";
      "eu4" = "steam steam://rungameid/236850";
      "ck3" = "steam steam://rungameid/1158310";
    };
  };
}