{ inputs, ... }:
{
  flake.modules.homeManager.core =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.bat-extras.batgrep ];

      programs.bat.enable = true;
      programs.bat.config.theme = "srcery";
      xdg.configFile."bat/themes/srcery.tmTheme".source = "${inputs.srcery-textmate}/srcery.tmTheme";
      home.sessionVariables.MANPAGER = pkgs.bat-extras.batman;
    };
}
