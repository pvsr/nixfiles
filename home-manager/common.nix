{
  config,
  pkgs,
  lib,
  ...
}: let
  colors = import ./colors.nix;
in {
  imports = [
    ./fish.nix
    ./tmux.nix
    ./helix
    ./git.nix
  ];

  programs.home-manager.enable = true;

  home.stateVersion = "22.11";

  home.packages = with pkgs; [
    stow
    gitAndTools.git-annex
    git-absorb
    fd
    ripgrep
    moreutils
    atool
    pastel
    alejandra
    ranger
    tig
    manix
    nvd
    sd
    duf
    du-dust
  ];

  home.language.base = "en-US.UTF-8";

  home.shellAliases = {
    bell = "echo \\a";

    "hoi4" = "steam steam://rungameid/394360";
    "eu4" = "steam steam://rungameid/236850";
    "ck3" = "steam steam://rungameid/1158310";
    "vic3" = "steam steam://rungameid/529340";
  };

  # needed for aliases to work
  programs.bash.enable = lib.mkDefault true;

  programs.man.generateCaches = true;

  programs.direnv = {
    enable = true;
    enableBashIntegration = false;
    nix-direnv.enable = true;
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

  programs.nix-index.enable = true;
  programs.tealdeer.enable = true;
  programs.bat.enable = true;
  programs.htop.enable = true;
  programs.password-store.enable = true;
  programs.jq.enable = true;
  programs.zoxide.enable = true;

  programs.eza.enable = true;
  programs.eza.enableAliases = true;

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
