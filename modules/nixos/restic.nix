{ lib, ... }:
let
  commonConfig = pkgs: {
    user = "restic";
    package = pkgs.writeShellScriptBin "restic" ''
      exec /run/wrappers/bin/restic "$@"
    '';
    createWrapper = true;
    initialize = true;
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
  };
in
{
  flake.modules.nixos.core =
    { config, pkgs, ... }:
    let
      enabled = config.services.restic.backups != { };
    in
    {
      config = lib.mkIf enabled {
        users.users.restic = {
          isNormalUser = true;
          openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEBLq7YdrhOBxEGFOU4ezhFyq0YdND9C2Qnv+yxjKD// restic@grancel"
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHsFSpgVCk5YBnfGnf7CZ/IlSVlSf9Ys0Tdj22kFOHZV restic@ruan"
          ]
          ++ config.local.user.openssh.authorizedKeys.keys;
        };

        security.wrappers.restic = {
          source = "${pkgs.restic.out}/bin/restic";
          owner = "restic";
          group = "users";
          permissions = "u=rx,g=rx,o=";
          capabilities = "cap_dac_read_search=+ep";
        };
      };
    };

  local.desktops.grancel = { pkgs, ... }: {
    services.restic.backups.system = (commonConfig pkgs) // {
      repository = "/run/media/restic";
      passwordFile = "/run/media/restic/password";
      paths = [
        "/home/peter"
        "/var/lib"
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

  # TODO automatically copy backups from other machines
  local.desktops.ruan = { pkgs, ... }: {
    services.restic.backups.external = (commonConfig pkgs) // {
      repository = "/run/media/leiston/restic";
      passwordFile = "/run/media/leiston/restic/password";
      paths = [
        "/home/peter"
        "/run/media/persist"
      ];
      timerConfig = {
        Persistent = true;
        OnCalendar = "05:00";
      };
      pruneOpts = [
        "--keep-daily 7"
        "--keep-weekly 4"
        "--keep-monthly 6"
      ];
    };
  };
}
