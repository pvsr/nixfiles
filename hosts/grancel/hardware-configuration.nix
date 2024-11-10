{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    inputs.nixos-hardware.nixosModules.common-cpu-amd-zenpower
    inputs.nixos-hardware.nixosModules.common-gpu-amd
  ];

  hardware.enableRedistributableFirmware = true;
  # TODO remove once linux_default is above 6.6
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "ahci"
    "usbhid"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-label/grancel";
    fsType = "bcachefs";
    options = [
      "defaults"
      "compress=zstd"
    ];
  };

  fileSystems."/media/valleria" = {
    device = "/dev/disk/by-label/valleria";
    fsType = "bcachefs";
    options = [
      "defaults"
      "compress=zstd"
    ];
  };

  fileSystems."/media/gdata2" = {
    device = "/dev/disk/by-label/valleria";
    fsType = "btrfs";
    options = [
      "defaults"
      "compress=zstd"
    ];
  };

  # TODO swap
  # swapDevices = [ { device = "/var/lib/swap/swapfile"; } ];

  fileSystems."/boot" = {
    device = "/dev/disk/by-partlabel/disk-grancel-ESP";
    fsType = "vfat";
    options = [ "defaults" ];
  };
}
