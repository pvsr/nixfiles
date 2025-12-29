{
  flake.modules.hjem.core =
    { config, pkgs, ... }:
    {
      packages = [ pkgs.ripgrep ];

      xdg.config.files."ripgrep/config".text = "--smart-case";

      environment.sessionVariables.RIPGREP_CONFIG_PATH = "${config.xdg.config.directory}/ripgrep/config";
    };
}
