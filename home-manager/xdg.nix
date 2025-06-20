{
  flake.modules.homeManager.core =
    { config, pkgs, ... }:
    let
      inherit (config.xdg) dataHome stateHome;
    in
    {
      xdg.userDirs = {
        enable = pkgs.stdenv.hostPlatform.isLinux;
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
        CARGO_INSTALL_ROOT = "${config.home.homeDirectory}/.local";
        HISTFILE = "${stateHome}/bash/history";
        LESSHISTFILE = "${stateHome}/less/history";
      };
    };
}
