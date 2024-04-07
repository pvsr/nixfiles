{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-gpu-amd
  ];

  hardware.enableRedistributableFirmware = true;
  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci" "usbhid" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-amd"];
  boot.extraModulePackages = [];

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
}
