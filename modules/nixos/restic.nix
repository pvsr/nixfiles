{
  local.desktops.grancel =
    { pkgs, ... }:
    {
      users.users.restic = {
        isNormalUser = true;
      };

      security.wrappers.restic = {
        source = "${pkgs.restic.out}/bin/restic";
        owner = "restic";
        group = "users";
        permissions = "u=rx,g=rx,o=";
        capabilities = "cap_dac_read_search=+ep";
      };

      services.restic.backups = {
        system = {
          user = "restic";
          package = pkgs.writeShellScriptBin "restic" ''
            exec /run/wrappers/bin/restic "$@"
          '';
          createWrapper = true;
          initialize = true;
          repository = "/run/media/restic";
          passwordFile = "/run/media/restic/password";
          paths = [
            "/home/peter"
            "/var/lib"
          ];
          extraBackupArgs = [
            "--one-file-system"
            "--exclude-caches=true"
          ];
          exclude = [
            "/var/lib/systemd/coredump"
            "/var/lib/nixos-containers/*/var/log"
            "/var/lib/incus/images"
            "/var/lib/incus/storage-pools"
            "/home/*/.local/cache"
            "/home/*/.local/share/doc"
          ];
          timerConfig = {
            Persistent = true;
            OnCalendar = "07:00";
          };
          pruneOpts = [
            "--keep-daily 5"
            "--keep-weekly 3"
            "--keep-monthly 2"
          ];
        };
      };
    };
}
