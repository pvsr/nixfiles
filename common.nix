{ config, pkgs, ... }:

{
  imports = [
    ./fish.nix
    ./tmux.nix
    ./sway.nix
  ];

  home.packages = with pkgs; [
    neovim
    stow
    youtube-dl
    git
    gitAndTools.git-annex
    fd
    ripgrep
    htop
    transmission
    moreutils
    atool
    pass
    pastel
    #tmux
  ];

  services.lorri.enable = true;

  programs.direnv = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.git = {
    enable = true;
    ignores = [ "Session.vim" "healthcheck.out" ];
    userName = "Peter Rice";
    userEmail = "peter@peterrice.xyz";
  };

  programs.fzf = {
    enable = true;
    enableFishIntegration = false;
    defaultCommand = "fd --type f";
    defaultOptions = [
    "--bind=ctrl-j:accept,ctrl-k:kill-line"
    "--cycle"
    "--layout=reverse"
    ];
  };

  programs.keychain = {
    enable = true;
    enableFishIntegration = false;
    agents = [ "gpg" "ssh" ];
    keys = [ "id_ed25519" ];
    extraFlags = [ "--quiet" ];
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
        ytdl-raw-options =
          "sub-lang=\"eng,en,enUS,en-US\",write-sub=,write-auto-sub=";
      };
    };
  };

  programs.alacritty = with import ./colors.nix; {
    enable = true;
    settings = {

      draw_bold_text_with_bright_colors = true;
      font.normal.family = "Sarasa Term J";
      font.size = 12.0;
      colors = {
        primary.background = "${black}";
        primary.foreground = "${brightWhite}";

        normal = {
          black = "${black}";
          red = "${red}";
          green = "${green}";
          yellow = "${yellow}";
          blue = "${blue}";
          magenta = "${magenta}";
          cyan = "${cyan}";
          white = "${white}";
        };

        bright = {
          black = "${brightBlack}";
          red = "${brightRed}";
          green = "${brightGreen}";
          yellow = "${brightYellow}";
          blue = "${brightBlue}";
          magenta = "${brightMagenta}";
          cyan = "${brightCyan}";
          white = "${brightWhite}";
        };
      };
    };
  };
}
