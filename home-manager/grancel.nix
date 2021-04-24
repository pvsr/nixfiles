{ config, pkgs, ... }:

{
  programs.home-manager.enable = true;

  imports = [
    ./common.nix
    ./linux.nix
    ./kakoune.nix
  ];

  targets.genericLinux.enable = true;
  targets.genericLinux.extraXdgDataDirs = [ "/usr/share" ];

  home.username = "peter";
  home.homeDirectory = "/home/peter";

  home.packages = with pkgs; [
    deploy-rs
  ];

  home.language.base = "en-US.UTF-8";

  programs.beets.enable = false;
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

  #home.stateVersion = "21.05";
}
