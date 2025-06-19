{ inputs, ... }:
{
  flake.modules.homeManager.core =
    { pkgs, ... }:
    {
      home.packages = with pkgs.bat-extras; [
        batgrep
        batman
      ];

      programs.bat.enable = true;
      programs.bat.config.theme-dark = "srcery";
      xdg.configFile."bat/themes/srcery.tmTheme".source = "${inputs.srcery-textmate}/srcery.tmTheme";
      home.sessionVariables.MANPAGER = pkgs.writeShellScript "batman" ''
        awk '{ gsub(/\x1B\[[0-9;]*m/, "", $0); gsub(/.\x08/, "", $0); print }' \
        | bat --plain --language man
      '';
    };
}
