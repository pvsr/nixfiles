{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./river/river.nix
  ];

  home.packages = with pkgs; [
    diceware
    qbpm
    qutebrowser
    transmission
    youtube-dl
    neovide
  ];

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 3 * 60 * 60;
    maxCacheTtl = 8 * 60 * 60;
    pinentryFlavor = "qt";
  };

  programs.mpv.enable = true;

  programs.beets.enable = true;
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

  xdg.configFile."youtube-dl/config".text = ''
    -f "bestvideo[height<=?2160]+bestaudio/best"
    --sub-lang="en,eng,enUS,en-US,ja,jaJP,ja-JP"
    --write-sub
    --write-auto-sub
    --netrc
  '';
}
