{
  config,
  lib,
  pkgs,
  ...
}: {
  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "usbhid" "uas" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-amd"];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/2f1cf9d8-5b5f-4d0f-89dc-ef52a1d0d174";
    fsType = "btrfs";
    options = ["subvol=root" "defaults" "compress=zstd"];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/2f1cf9d8-5b5f-4d0f-89dc-ef52a1d0d174";
    fsType = "btrfs";
    options = ["subvol=home" "defaults" "compress=zstd"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/AB78-74B8";
    fsType = "vfat";
    options = ["defaults"];
  };

  fileSystems."/media/data" = {
    device = "/dev/disk/by-uuid/367ffdb7-bfaf-4409-9115-5ecbe4261bae";
    fsType = "btrfs";
    options = ["defaults" "compress=zstd"];
  };

  fileSystems."/var/lib/transmission" = {
    device = "/dev/disk/by-uuid/367ffdb7-bfaf-4409-9115-5ecbe4261bae";
    fsType = "btrfs";
    options = ["subvol=transmission" "defaults" "compress=zstd"];
  };

  fileSystems."/media/steam" = {
    device = "/dev/disk/by-uuid/367ffdb7-bfaf-4409-9115-5ecbe4261bae";
    fsType = "btrfs";
    options = ["subvol=steam" "defaults" "compress=zstd"];
  };

  fileSystems."/media/nixos" = {
    device = "/dev/disk/by-uuid/2f1cf9d8-5b5f-4d0f-89dc-ef52a1d0d174";
    fsType = "btrfs";
    options = ["defaults" "compress=zstd"];
  };

  fileSystems."/media/leiston" = {
    device = "/dev/disk/by-uuid/c76abfad-5b5a-478f-a85e-dde18ffe202f";
    fsType = "btrfs";
    options = ["nofail" "defaults" "compress=zstd"];
  };

  swapDevices = [];

  hardware.video.hidpi.enable = lib.mkDefault true;
}
