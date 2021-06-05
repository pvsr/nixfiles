{ config, pkgs, lib, fishPlugins, ... }:
let fzfKeyBindings = ''
  if type __fzf_search_current_dir &> /dev/null
    bind \co __fzf_search_current_dir
    bind \cr __fzf_search_history
    bind \cv $fzf_search_vars_cmd
    bind \e\cl __fzf_search_git_log
    bind \e\cs __fzf_search_git_status
    bind --mode insert \co __fzf_search_current_dir
    bind --mode insert \cr __fzf_search_history
    bind --mode insert \cv $fzf_search_vars_cmd
    bind --mode insert \e\cl __fzf_search_git_log
    bind --mode insert \e\cs __fzf_search_git_status
  end
'';
in
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
    '' + fzfKeyBindings;
    shellAbbrs = {
      suod = "sudo";
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
    plugins =
      let genPlugin = name: {
        inherit name;
        src = lib.getAttr name fishPlugins;
      };
      in
      map genPlugin [
        "fish-prompt-pvsr"
        "z"
        "fzf"
        "plugin-git"
      ];
  };

  programs.fzf.enableFishIntegration = false;
}
