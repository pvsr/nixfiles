{ config, pkgs, lib, ... }:
let colors = import ./colors.nix; in
{
  imports = [
    ./fish.nix
    ./tmux.nix
    ./neovim/neovim.nix
  ];

  home.packages = with pkgs; [
    stow
    youtube-dl
    gitAndTools.git-annex
    fd
    ripgrep
    htop
    moreutils
    atool
    pass
    pastel
  ];

  home.sessionVariables = {
    RIPGREP_CONFIG_PATH = "~/.config/rg/rc";
    BROWSER = "org.qutebrowser.qutebrowser.desktop";
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  xdg.configFile."rg/rc".text = "--smart-case";

  programs.direnv = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    ignores = [ "Session.vim" "healthcheck.out" ".envrc" ];
    userName = "Peter Rice";
    userEmail = lib.mkDefault "peter@peterrice.xyz";
    delta.enable = true;
    extraConfig = {
      commit.verbose = true;
      pull.rebase = true;
    };
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
    agents = [ "gpg" "ssh" ];
    keys = [ "id_rsa" "id_ed25519" ];
    extraFlags = [ "--noask" "--quiet" ];
  };

  services.mpd = {
    musicDirectory = ~/annex/music;
  };

  programs.mpv = {
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

  programs.alacritty = {
    enable = true;
    settings = {
      window.dynamic_title = true;
      draw_bold_text_with_bright_colors = true;
      font.normal.family = "Sarasa Term J";
      font.size = 12.0;
      colors = with colors; {
        primary.background = black;
        primary.foreground = brightWhite;

        normal = {
          inherit black red green yellow blue magenta cyan white;
        };

        bright = {
          black = brightBlack;
          red = brightRed;
          green = brightGreen;
          yellow = brightYellow;
          blue = brightBlue;
          magenta = brightMagenta;
          cyan = brightCyan;
          white = brightWhite;
        };
      };
    };
  };
}
