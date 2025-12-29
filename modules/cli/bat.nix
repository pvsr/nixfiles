{ inputs, ... }:
{
  flake.modules.hjem.core =
    { pkgs, ... }:
    {
      packages = with pkgs; [
        bat
        bat-extras.batgrep
        bat-extras.batman
      ];

      xdg.config.files."bat/config".text = "--theme-dark=srcery";
      xdg.config.files."bat/themes/srcery.tmTheme".source = "${inputs.srcery-textmate}/srcery.tmTheme";
      environment.sessionVariables.MANPAGER = toString (
        pkgs.writeShellScript "batman" ''
          awk '{ gsub(/\x1B\[[0-9;]*m/, "", $0); gsub(/.\x08/, "", $0); print }' \
          | bat --plain --language man
        ''
      );
    };
}
