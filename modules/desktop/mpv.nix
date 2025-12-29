{ lib, ... }:
let
  profiles = {
    wayland = {
      profile = "standard";
      gpu-context = "wayland";
    };
    no-term = {
      profile = "standard";
      pause = "yes";
      force-window = "immediate";
      terminal = "no";
    };
    "protocol.https" = {
      force-window = "immediate";
      keep-open = "yes";
    };
    "protocol.http" = {
      profile = "protocol.https";
    };
    standard = {
      cache = "yes";
      audio-display = "no";
      write-filename-in-watch-later-config = "yes";
      profile = "gpu-hq";
      video-sync = "display-resample";
      interpolation = "yes";
      tscale = "oversample";
      demuxer-mkv-subtitle-preroll = "yes";
      slang = "eng,en,enUS,en-US";
      ytdl-raw-options = "sub-langs=\"en*\",cookies-from-browser=firefox";
      # for thumbnail/youtube-quality
      osc = "no";
      script-opts-append = "autocrop-auto=no";
    };
  };
in
{
  flake.modules.hjem.core.options.mpv.defaultProfile = lib.mkOption { default = "standard"; };

  flake.modules.hjem.desktop =
    { config, pkgs, ... }:
    {
      packages = with pkgs; [
        yt-dlp
        (mpv.override {
          scripts = with mpvScripts; [
            autocrop
            mpris
            sponsorblock

            # mutually exclusive osc replacements
            thumbnail
            # youtube-quality
          ];
        })
      ];

      xdg.config.files."mpv/mpv.conf".text = ''
        profile=${config.mpv.defaultProfile}

        ${lib.generators.toINI { listsAsDuplicateKeys = true; } profiles}
      '';

      xdg.config.files."yt-dlp/config".text = ''
        --embed-subs
        --embed-thumbnail
        --sub-langs en*,ja*
        --write-auto-subs
      '';

      fish = {
        interactiveShellInit = ''
          abbr -a mshuf 'mpv --no-video --shuffle ~/annex/music'
          abbr -a pmpv 'umpv (wl-paste)'
          abbr -a uts 'umpv (wl-paste)'
        '';
        wrappers.mpv.yts = "mpv 'ytdl://ytsearch1:'$argv[1] $argv[2..-1]";
        wrappers.mpv.uts = "umpv 'ytdl://ytsearch1:'$argv[1] $argv[2..-1]";
        functions.m = ''
          commandline 'mpv --no-video ~/music/'
          set -x fzf_fd_opts -td --exact-depth 2
          _fzf_search_directory
        '';
      };
    };
}
