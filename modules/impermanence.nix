{
  config,
  lib,
  inputs,
  ...
}:
let
  cfg = config.impermanence;
in
{
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  options.impermanence = {
    enable = lib.mkEnableOption { };
    device = lib.mkOption { };
    persist = lib.mkOption { };
  };

  config = lib.mkIf cfg.enable {
    users.mutableUsers = false;
    users.users.root.hashedPasswordFile = "${cfg.persist}/passwords/root";
    users.users.peter.hashedPasswordFile = "${cfg.persist}/passwords/peter";
    environment.persistence.${cfg.persist} = {
      hideMounts = true;
      directories = [
        "/var/log"
        "/var/lib/bluetooth"
        "/var/lib/machines"
        "/var/lib/nixos"
        "/var/lib/systemd"
        "/var/lib/tailscale"
        "/etc/nixos"
      ];
      files = [
        "/etc/machine-id"
        "/etc/ssh/ssh_host_ed25519_key"
        "/etc/ssh/ssh_host_ed25519_key.pub"
        "/etc/ssh/ssh_host_rsa_key"
        "/etc/ssh/ssh_host_rsa_key.pub"
      ];
    };

    # TODO debug postDeviceCommands with systemd-initrd (change id: myz)
    boot.initrd.systemd.enable = false;
    boot.initrd.postDeviceCommands = lib.mkAfter ''
      mkdir /mnt
      mount ${cfg.device} /mnt

      delete_subvolume_recursively() {
          IFS=$'\n'
          for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
              delete_subvolume_recursively "/mnt/$i"
          done
          btrfs subvolume delete "$1"
      }

      if [[ -e /mnt/tmp_root ]]; then
        if [[ -e /mnt/old_root ]]; then
          btrfs subvolume delete /mnt/old_root
        fi
        btrfs subvolume snapshot -r /mnt/tmp_root /mnt/old_root
        delete_subvolume_recursively /mnt/tmp_root
      fi

      btrfs subvolume create /mnt/tmp_root
    '';
  };
}
