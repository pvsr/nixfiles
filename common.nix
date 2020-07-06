{ config, pkgs, lib, ... }:

{
  imports = [
    ./fish.nix
    ./tmux.nix
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
    moreutils
    atool
    pass
    pastel
    #tmux
  ];

  programs.direnv = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.git = {
    enable = true;
    ignores = [ "Session.vim" "healthcheck.out" ];
    userName = "Peter Rice";
    userEmail = lib.mkDefault "peter@peterrice.xyz";
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
    keys = [ "id_rsa" "id_ed25519" ];
    extraFlags = [ "--quiet" ];
  };

  services.mpd = {
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
        video-sync = "display-resample";
        interpolation = true;
        tscale = "oversample";
        demuxer-mkv-subtitle-preroll = true;
        # TODO
        slang = "eng,en,enUS,en-US";
        ytdl-raw-options =
          "sub-lang=\"eng,en,enUS,en-US\",write-sub=,write-auto-sub=,cookies=~/.cache/cookies.txt";
      };
    };
  };

  programs.alacritty = with import ./colors.nix; {
    enable = true;
    settings = {
      dynamic_title = true;
      draw_bold_text_with_bright_colors = true;
      font.normal.family = "Sarasa Term J";
      font.size = lib.mkDefault 12.0;
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
