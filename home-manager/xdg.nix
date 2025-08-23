{
  flake.modules.nixos.core =
    { config, ... }:
    {
      environment.sessionVariables = {
        XDG_CONFIG_HOME = "$HOME/.local/config";
        XDG_CACHE_HOME = "$HOME/.local/cache";
      };
    };
  flake.modules.homeManager.core =
    { config, pkgs, ... }:
    let
      inherit (config.home) homeDirectory;
      inherit (config.xdg) dataHome stateHome;
    in
    {
      xdg.configHome = "${homeDirectory}/.local/config";
      xdg.cacheHome = "${homeDirectory}/.local/cache";
      xdg.userDirs = {
        enable = pkgs.stdenv.hostPlatform.isLinux;
        desktop = "${homeDirectory}/desktop";
        documents = "${homeDirectory}/documents";
        download = "${homeDirectory}/downloads";
        music = "${homeDirectory}/music";
        pictures = "${homeDirectory}/pictures";
        publicShare = "${homeDirectory}/public";
        templates = "${homeDirectory}/templates";
        videos = "${homeDirectory}/videos";
      };

      home.preferXdgDirectories = true;
      home.sessionVariables = {
        CARGO_HOME = "${dataHome}/cargo";
        CARGO_INSTALL_ROOT = "${homeDirectory}/.local";
        HISTFILE = "${stateHome}/bash/history";
        LESSHISTFILE = "${stateHome}/less/history";
      };
    };
}
