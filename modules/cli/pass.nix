{
  local.desktops.grancel =
    { pkgs, ... }:
    {
      programs.gnupg.agent.enable = true;
      programs.gnupg.agent.pinentryPackage = pkgs.pinentry-curses;
      programs.gnupg.agent.settings = {
        default-cache-ttl-ssh = 3 * 60 * 60;
        max-cache-ttl = 8 * 60 * 60;
      };
    };

  flake.modules.hjem.grancel =
    { config, pkgs, ... }:
    {
      packages = [
        pkgs.pass
        pkgs.gnupg
      ];

      environment.sessionVariables.PASSWORD_STORE_DIR = "${config.xdg.data.directory}/password-store";
      environment.sessionVariables.GNUPGHOME = "${config.xdg.data.directory}/gnupg";

      fish.interactiveShellInit = ''
        set -gx GPG_TTY (tty)
        ${pkgs.gnupg}/bin/gpg-connect-agent --quiet updatestartuptty /bye > /dev/null
      '';
    };
}
