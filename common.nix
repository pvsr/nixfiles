{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    neovim
    stow
    youtube-dl
    git
    gitAndTools.git-annex
    fd
    ripgrep
    lsof
    htop
    transmission
    moreutils
    atool
    pass
    #tmux
  ];

  programs.direnv = {
    enable = true;
    enableFishIntegration = true;
  };

  services.lorri.enable = true;

  programs.git = {
    enable = true;
    ignores = [ "Session.vim" ];
    userName = "Peter Rice";
    userEmail = "peter@peterrice.xyz";
  };

  programs.fzf = {
    enable = true;
    enableFishIntegration = false;
    defaultCommand = "fd --type f";
    defaultOptions = [ "--bind=ctrl-j:accept,ctrl-k:kill-line" ];
  };

  services.mpd = {
    enable = true;
    musicDirectory = ~/annex/music;
  };

  programs.mpv = {
    enable = true;
    bindings = { };
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
      standard = {
        cache = true;
        audio-display = false;
        write-filename-in-watch-later-config = true;
        # TODO
        ytdl-format = "bestvideo[height<=?2160]+bestaudio/best";
        profile = "gpu-hq";
        gpu-context = "wayland";
        video-sync = "display-resample";
        interpolation = true;
        tscale = "oversample";
        demuxer-mkv-subtitle-preroll = true;
        # TODO
        slang = "eng,en,enUS,en-US";
        ytdl-raw-options = "sub-lang=\"eng,en,enUS,en-US\",write-sub=";
      };
    };
  };
}
