{ pkgs, ... }:
{
  imports = [
    ./fish.nix
    ./tmux.nix
    ./helix
    ./git.nix
    ./jujutsu.nix
    ./xdg.nix
  ];

  programs.home-manager.enable = true;

  home.stateVersion = "24.05";

  home.packages = with pkgs; [
    fd
    ripgrep
    moar
    nvd
    nix-output-monitor
    duf
    du-dust
    (ranger.override {
      imagePreviewSupport = false;
      sixelPreviewSupport = false;
    })
    (symlinkJoin {
      name = "timg-wrapped";
      paths = [ timg ];
      buildInputs = [ makeWrapper ];
      postBuild = "wrapProgram $out/bin/timg --add-flags '-pk'";
    })
  ];

  home.sessionVariables = {
    PAGER = "${pkgs.moar}/bin/moar";
    MOAR = builtins.concatStringsSep " " [
      "-quit-if-one-screen"
      "-statusbar=bold"
      "-no-statusbar"
      "-no-linenumbers"
      "-no-clear-on-exit"
      "-terminal-fg"
    ];
  };

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
