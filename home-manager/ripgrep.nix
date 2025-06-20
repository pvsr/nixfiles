{
  flake.modules.homeManager.core =
    { config, pkgs, ... }:
    {
      home.packages = [ pkgs.ripgrep ];

      home.sessionVariables.RIPGREP_CONFIG_PATH = "${config.xdg.configHome}/ripgrep/config";

      xdg.configFile."ripgrep/config".text = "--smart-case";
    };
}
