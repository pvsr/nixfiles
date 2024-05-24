{
  config,
  pkgs,
  ...
}: {
  imports = [
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

  xdg.userDirs = {
    enable = true;
    desktop = "${config.home.homeDirectory}/desktop";
    documents = "${config.home.homeDirectory}/documents";
    download = "${config.home.homeDirectory}/downloads";
    music = "${config.home.homeDirectory}/music";
    pictures = "${config.home.homeDirectory}/pictures";
    publicShare = "${config.home.homeDirectory}/public";
    templates = "${config.home.homeDirectory}/templates";
    videos = "${config.home.homeDirectory}/videos";
  };

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
    plugins = ["random" "scrub" "ftintitle" "fetchart" "chroma"];
    original_date = true;
    from_scratch = true;
    mpd.host = "localhost";
    mpd.port = 6600;
    match.preferred = {
      countries = ["XW" "US" "JP"];
      media = ["Digital Media|File" "CD"];
      original_year = true;
    };
    scrub.auto = true;
  };
}
