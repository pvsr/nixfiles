{ pkgs, ... }:
{
  imports = [
    ./config.nix
    ./fish.nix
    ./ripgrep.nix
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
    moar
    nvd
    nix-output-monitor
    duf
    du-dust
    (ranger.override {
      imagePreviewSupport = false;
      sixelPreviewSupport = false;
    })
    (fzf.overrideAttrs (oldAttrs: {
      postInstall = ''
        ${oldAttrs.postInstall or ""}
        rm -rf $out/share/fish
      '';
    }))
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
    FZF_DEFAULT_OPTIONS = builtins.concatStringsSep " " [
      "--bind=ctrl-j:accept,ctrl-k:kill-line"
      "--cycle"
      "--layout=reverse"
    ];
  };

  home.language.base = "en-US.UTF-8";

  home.shellAliases.bell = "echo \\a";

  programs.bottom.enable = true;
}
