{ inputs, ... }:
{
  flake.modules.homeManager.desktop =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        gitAndTools.git-annex
        moreutils
        ouch
        tig
        manix
        sd
        diceware
        transmission_4
        nvtopPackages.amd
        (pkgs.symlinkJoin {
          name = "timg-wrapped";
          paths = [ pkgs.timg ];
          buildInputs = [ pkgs.makeWrapper ];
          postBuild = "wrapProgram $out/bin/timg --add-flags '-pk'";
        })
        inputs.qbpm.packages.${pkgs.system}.qbpm
      ];

      programs.direnv = {
        enable = true;
        enableBashIntegration = false;
        nix-direnv.enable = true;
      };
      services.lorri.enable = true;

      programs.nix-index.enable = true;
      programs.tealdeer.enable = true;
      programs.bat.enable = true;
      programs.password-store.enable = true;
      programs.jq.enable = true;
      programs.zoxide.enable = true;

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
            # TODO
            slang = "eng,en,enUS,en-US";
            ytdl-raw-options = "sub-langs=\"en*,ja*\"";
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
    };
}
