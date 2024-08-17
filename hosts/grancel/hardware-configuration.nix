{
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    inputs.nixos-hardware.nixosModules.common-cpu-amd-zenpower
    inputs.nixos-hardware.nixosModules.common-gpu-amd
  ];

  hardware.enableRedistributableFirmware = true;
  # TODO remove when default catches up
  boot.kernelPackages = pkgs.linuxPackages_6_8;
  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci" "usbhid" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-amd"];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "/dev/disk/by-label/grancel";
    fsType = "btrfs";
    options = ["subvol=tmp_root" "defaults" "compress=zstd"];
  };

  # TODO debug postDeviceCommands with systemd-initrd (change id: myz)
  boot.initrd.systemd.enable = false;
  boot.initrd.postDeviceCommands = lib.mkAfter ''
    mkdir /mnt
    mount /dev/disk/by-label/grancel /mnt

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

  fileSystems."/media/grancel" = {
    device = "/dev/disk/by-label/grancel";
    neededForBoot = true;
    fsType = "btrfs";
    options = ["defaults" "compress=zstd"];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-label/grancel";
    fsType = "btrfs";
    options = ["subvol=nix" "defaults" "compress=zstd"];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-label/grancel";
    fsType = "btrfs";
    options = ["subvol=home" "defaults" "compress=zstd"];
  };

  fileSystems."/var/lib/swap" = {
    device = "/dev/disk/by-label/grancel";
    fsType = "btrfs";
    options = ["subvol=swap"];
  };

  swapDevices = [{device = "/var/lib/swap/swapfile";}];

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
    options = ["defaults"];
  };
}
