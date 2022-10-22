{
  config,
  pkgs,
  ...
}: {
  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToControl = true;
  homebrew.enable = true;
  homebrew.casks = [
    "alacritty"
    "firefox"
    "intellij-idea-ce"
    "sequel-ace"
    "spotify"
  ];
}
