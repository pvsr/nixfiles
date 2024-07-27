{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./fish.nix
    ./tmux.nix
    ./helix
    ./git.nix
    ./jujutsu.nix
    ./xdg.nix
  ];

  programs.home-manager.enable = true;

  home.stateVersion = "22.11";

  home.packages = with pkgs; [
    fd
    ripgrep
    nvd
    duf
    du-dust
    (ranger.override {
      imagePreviewSupport = false;
      sixelPreviewSupport = false;
    })
  ];

  home.language.base = "en-US.UTF-8";

  home.shellAliases.bell = "echo \\a";

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

  programs.bottom.enable = true;
}
