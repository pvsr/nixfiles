{ config, pkgs, ... }:
{
  imports = [
    ./desktop.nix
    ./niri
  ];

  home.packages = with pkgs; [
    diceware
    qbpm
    qutebrowser
    transmission
  ];

  home.pointerCursor = {
    package = pkgs.vanilla-dmz;
    name = "Vanilla-DMZ";
    gtk.enable = true;
  };

  programs.gpg.enable = true;
  programs.gpg.homedir = "${config.xdg.dataHome}/gnupg";
  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 3 * 60 * 60;
    maxCacheTtl = 8 * 60 * 60;
    pinentryPackage = pkgs.pinentry-curses;
  };

  programs.mpv.enable = true;
  programs.yt-dlp.enable = true;
  programs.yt-dlp.settings = {
    embed-subs = true;
    write-auto-subs = true;
    embed-thumbnail = true;
    sub-langs = "en*,ja*";
  };

  programs.beets.settings = {
    directory = "~/music";
    library = "~/library.blb";
    plugins = [
      "random"
      "scrub"
      "ftintitle"
      "fetchart"
      "chroma"
    ];
    original_date = true;
    from_scratch = true;
    mpd.host = "localhost";
    mpd.port = 6600;
    match.preferred = {
      countries = [
        "XW"
        "US"
        "JP"
      ];
      media = [
        "Digital Media|File"
        "CD"
      ];
      original_year = true;
    };
    scrub.auto = true;
  };
}
