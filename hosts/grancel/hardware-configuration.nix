{
  config,
  lib,
  pkgs,
  ...
}: {
  hardware.enableRedistributableFirmware = true;
  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-amd"];
  boot.extraModulePackages = [];

  networking.interfaces.enp4s0.useDHCP = true;
  # networking.interfaces.wlp3s0.useDHCP = true;

  fileSystems."/" = {
    device = "/dev/disk/by-label/grancel";
    fsType = "btrfs";
    options = ["subvol=root" "defaults" "compress=zstd"];
  };

  fileSystems."/media/grancel" = {
    device = "/dev/disk/by-label/grancel";
    fsType = "btrfs";
    options = ["defaults" "compress=zstd"];
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

  fileSystems."/media/gdata2" = {
    device = "/dev/disk/by-uuid/b29448d8-fe2b-4b80-8a27-2987665ddde6";
    fsType = "btrfs";
    options = ["defaults" "compress=zstd"];
  };
}
