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
    ./neovim
    ./helix
  ];

  programs.home-manager.enable = true;

  home.stateVersion = "22.11";

  home.packages = with pkgs; [
    stow
    youtube-dl
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
  ];

  home.language.base = "en-US.UTF-8";

  home.shellAliases = {
    nvim_nowrite = "nvim '+set noundofile' '+set noswapfile'";
    pass = "EDITOR=nvim_nowrite command pass";
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

  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    ignores = ["Session.vim" "healthcheck.out"];
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
    agents = ["ssh"];
    keys = ["id_rsa" "id_ed25519"];
    extraFlags = ["--noask" "--quiet"];
    enableBashIntegration = false;
  };

  programs.nix-index.enable = true;
  programs.tealdeer.enable = true;
  programs.bat.enable = true;
  programs.htop.enable = true;
  programs.password-store.enable = true;
  programs.jq.enable = true;

  programs.exa.enable = true;
  programs.exa.enableAliases = true;

  programs.mpv = {
    bindings = {};
    scripts = [pkgs.mpvScripts.mpris];
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

  xdg.configFile."youtube-dl/config".text = ''
    -f "bestvideo[height<=?2160]+bestaudio/best"
    --sub-lang="en,eng,enUS,en-US,ja,jaJP,ja-JP"
    --write-sub
    --write-auto-sub
    --netrc
  '';
}
