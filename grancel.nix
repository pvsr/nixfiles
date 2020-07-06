{ config, pkgs, ... }:

{
  programs.home-manager.enable = true;

  imports = [
    ./common.nix
    ./sway.nix
  ];

  home.packages = with pkgs; [
  ];

  home.file."bin/alacritty".text = "#!/bin/sh\n/usr/bin/alacritty \"$@\"";
  programs.fish.shellAliases = {
    mpv = "/usr/bin/mpv";
  };

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
      countries = ["XW" "US" "JP"];
      media = ["CD" "Digital Media|File"];
      original_year = true;
    };
    ftintitle.drop = true;
    embedart.remove_art_file = true;
    fetchart.sources = [ "coverart" "filesystem" ];
    scrub.auto = true;
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "20.03";
}
