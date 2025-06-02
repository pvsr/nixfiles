{
  flake.modules.nixos.grancel =
    { pkgs, ... }:
    {
      users.users.restic = {
        isNormalUser = true;
      };

      security.wrappers.restic = {
        source = "${pkgs.restic.out}/bin/restic";
        owner = "restic";
        group = "users";
        permissions = "u=rwx,g=,o=";
        capabilities = "cap_dac_read_search=+ep";
      };

      services.restic.backups = {
        system = {
          passwordFile = "/run/media/restic/password";
          repository = "/run/media/restic";
          user = "restic";
          package = pkgs.writeShellScriptBin "restic" ''
            exec /run/wrappers/bin/restic "$@"
          '';
          initialize = true;
          paths = [
            "/var/lib"
            "/home/peter/src"
            "/home/peter/notes"
            "/home/peter/games"
            "/home/peter/.local"
            "/home/peter/.mozilla"
          ];
          exclude = [
            "/var/log"
            "/var/lib/nixos-containers"
            "/home/*/.local/share/cargo"
            "/home/*/.local/share/doc"
            "/home/*/.local/share/uv"
          ];
          timerConfig = {
            Persistent = true;
            OnCalendar = "daily";
            FixedRandomDelay = true;
          };
        };
      };
    };
}
