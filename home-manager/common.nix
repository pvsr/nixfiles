{ config, pkgs, lib, ... }:
let colors = import ./colors.nix; in
{
  imports = [
    ./fish.nix
    ./tmux.nix
    ./neovim/neovim.nix
  ];

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    stow
    youtube-dl
    gitAndTools.git-annex
    git-absorb
    fd
    ripgrep
    bat
    htop
    moreutils
    atool
    pass
    pastel
    nixpkgs-fmt
    qbpm
    sarasa-gothic
    fantasque-sans-mono
  ];

  home.language.base = "en-US.UTF-8";

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  # TODO customize height per host
  xdg.configFile."youtube-dl/config".text = ''
    -f "bestvideo[height<=?2160]+bestaudio/best"
    --sub-lang="en,eng,enUS,en-US,ja,jaJP,ja-JP"
    --write-sub
    --write-auto-sub
    --netrc
  '';

  programs.direnv = {
    enable = true;
    enableFishIntegration = true;
    nix-direnv.enable = true;
  };

  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    ignores = [ "Session.vim" "healthcheck.out" ".envrc" ];
    userName = "Peter Rice";
    userEmail = lib.mkDefault "peter@peterrice.xyz";
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
    agents = [ "ssh" ];
    keys = [ "id_rsa" "id_ed25519" ];
    extraFlags = [ "--noask" "--quiet" ];
  };

  programs.nix-index.enable = true;

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
        profile = "gpu-hq";
        video-sync = "display-resample";
        interpolation = true;
        tscale = "oversample";
        demuxer-mkv-subtitle-preroll = true;
        # TODO
        slang = "eng,en,enUS,en-US";
      };
    };
  };
}
