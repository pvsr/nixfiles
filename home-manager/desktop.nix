{
  config,
  pkgs,
  lib,
  ...
}: let
  colors = import ./colors.nix;
in {
  imports = [
    ./common.nix
  ];

  home.packages = with pkgs; [
    gitAndTools.git-annex
    moreutils
    atool
    tig
    manix
    sd
  ];

  # TODO only if steam command exists
  home.shellAliases =
    lib.mapAttrs (n: id: "steam steam://rungameid/${id}")
    {
      "hoi4" = "394360";
      "eu4" = "236850";
      "ck3" = "1158310";
      "vic3" = "529340";
      "bg3" = "1086940";
      "p5r" = "1687950";
    };

  programs.man.generateCaches = true;

  programs.direnv = {
    enable = true;
    enableBashIntegration = false;
    nix-direnv.enable = true;
  };

  programs.nix-index.enable = true;
  programs.tealdeer.enable = true;
  programs.bat.enable = true;
  programs.password-store.enable = true;
  programs.jq.enable = true;
  programs.zoxide.enable = true;

  programs.mpv = {
    bindings = {};
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
      straming = {
        profile = "standard";
        save-position-on-quit = true;
        keep-open = "always";
        keep-open-pause = false;
      };
      podcast = {
        profile = "standard";
        save-position-on-quit = true;
        input-ipc-server = "/run/user/1000/podcast.mpv-ipc";
      };
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
}
