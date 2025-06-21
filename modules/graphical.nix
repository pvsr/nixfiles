{
  flake.modules.nixos.desktop = {
    services.displayManager.ly.enable = true;
    # defaults to true when display manager is enabled (graphical-desktop.nix)
    services.speechd.enable = false;

    services.openssh.settings.AcceptEnv = "TERMINFO COLORTERM";

    # srcery
    console.colors = [
      "1c1b19"
      "ef2f27"
      "519f50"
      "fbb829"
      "2c78bf"
      "e02c6d"
      "0aaeb3"
      "baa67f"
      "918175"
      "f75341"
      "98bc37"
      "fed06e"
      "68a8e4"
      "ff5c8f"
      "2be4d0"
      "fce8c3"
    ];
  };
}
