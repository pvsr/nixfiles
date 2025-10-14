let
  configPath = ".local/config";
  cachePath = ".local/cache";
in
{
  flake.modules.nixos.core = {
    environment.sessionVariables.XDG_CONFIG_HOME = "$HOME/${configPath}";
    environment.sessionVariables.XDG_CACHE_HOME = "$HOME/${cachePath}";
  };

  flake.modules.hjem.core =
    { config, lib, ... }:
    let
      dataDir = config.xdg.data.directory;
      stateDir = config.xdg.state.directory;
      userDirs = {
        XDG_DESKTOP_DIR = "$HOME/desktop";
        XDG_DOCUMENTS_DIR = "$HOME/documents";
        XDG_DOWNLOAD_DIR = "$HOME/downloads";
        XDG_MUSIC_DIR = "$HOME/music";
        XDG_PICTURES_DIR = "$HOME/pictures";
        XDG_PUBLICSHARE_DIR = "$HOME/public";
        XDG_TEMPLATES_DIR = "$HOME/templates";
        XDG_VIDEOS_DIR = "$HOME/videos";
      };
    in
    {
      xdg.config.directory = "${config.directory}/${configPath}";
      xdg.cache.directory = "${config.directory}/${cachePath}";
      environment.sessionVariables = userDirs // {
        CARGO_HOME = "${dataDir}/cargo";
        CARGO_INSTALL_ROOT = "$HOME/.local";
        HISTFILE = "${stateDir}/bash/history";
        LESSHISTFILE = "${stateDir}/less/history";
      };

      xdg.config.files."user-dirs.conf".text = "enabled=False";
      xdg.config.files."user-dirs.dirs".text = lib.concatMapAttrsStringSep "\n" (
        name: value: ''${name}="${value}"''
      ) userDirs;
    };
}
