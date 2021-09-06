{ config, pkgs, ... }:

{
  imports = [
    ./sway.nix
  ];

  home.packages = with pkgs; [
    diceware
    qutebrowser
  ];

  programs.mpv.enable = true;

  programs.beets.enable = true;
  programs.beets.settings = {
    directory = "~/music";
    library = "~/library.blb";
    plugins = [ "random" "scrub" "ftintitle" "embedart" "fetchart" "chroma" "lyrics" "scrub" ];
    original_date = true;
    from_scratch = true;
    mpd.host = "localhost";
    mpd.port = 6600;
    match.preferred = {
      countries = [ "XW" "US" "JP" ];
      media = [ "CD" "Digital Media|File" ];
      original_year = true;
    };
    ftintitle.drop = true;
    embedart.remove_art_file = true;
    fetchart.sources = [ "coverart" "filesystem" ];
    scrub.auto = true;
  };
}
