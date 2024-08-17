{
  config,
  ...
}: let
  inherit (config.xdg) cacheHome configHome dataHome stateHome;
in {
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

  home.preferXdgDirectories = true;
  home.sessionVariables = {
    CARGO_HOME = "${dataHome}/cargo";
    HISTFILE = "${stateHome}/bash/history";
    LESSHISTFILE = "${stateHome}/less/history";
  };
}
