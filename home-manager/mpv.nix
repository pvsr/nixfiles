{
  flake.modules.homeManager.desktop =
    { pkgs, ... }:
    {
      programs.mpv.enable = true;
      programs.mpv = {
        bindings = { };
        scripts = with pkgs.mpvScripts; [
          autocrop
          mpris
          sponsorblock

          # mutually exclusive osc replacements
          thumbnail
          # youtube-quality
        ];
        config = {
          profile = "standard";
        };
        profiles = {
          no-term = {
            profile = "standard";
            pause = true;
            force-window = "immediate";
            terminal = false;
          };
          "protocol.https" = {
            force-window = "immediate";
            keep-open = true;
          };
          "protocol.http" = {
            profile = "protocol.https";
          };
          standard = {
            cache = true;
            audio-display = false;
            write-filename-in-watch-later-config = true;
            profile = "gpu-hq";
            video-sync = "display-resample";
            interpolation = true;
            tscale = "oversample";
            demuxer-mkv-subtitle-preroll = true;
            slang = "eng,en,enUS,en-US";
            ytdl-raw-options = "sub-langs=\"en*\",cookies-from-browser=firefox";
            # for thumbnail/youtube-quality
            osc = false;
            script-opts-append = "autocrop-auto=no";
          };
        };
      };

      programs.yt-dlp.enable = true;
      programs.yt-dlp.settings = {
        embed-subs = true;
        write-auto-subs = true;
        embed-thumbnail = true;
        sub-langs = "en*,ja*";
      };

      programs.fish = {
        shellAbbrs.pmpv = "umpv (wl-paste)";
        functions.yts = {
          wraps = "mpv";
          body = "mpv 'ytdl://ytsearch1:'$argv[1] $argv[2..-1]";
        };
        functions.uts = {
          wraps = "mpv";
          body = "umpv 'ytdl://ytsearch1:'$argv[1] $argv[2..-1]";
        };

        functions.m = ''
          commandline 'mpv --no-video ~/music/'
          set -x fzf_fd_opts -td --exact-depth 2
          _fzf_search_directory
        '';
        shellAbbrs.mshuf = {
          setCursor = true;
          expansion = "mpv --shuffle --no-video ~/music/%";
        };
      };
    };
}
