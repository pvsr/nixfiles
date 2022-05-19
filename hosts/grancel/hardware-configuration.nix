{ config, lib, pkgs, ... }:
{
  hardware.enableRedistributableFirmware = true;
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/6c9585d7-bf04-4f3a-8455-a7d025d68c5d";
      fsType = "btrfs";
      options = [ "subvol=root" ];
    };

  fileSystems."/media/grancel" =
    {
      device = "/dev/disk/by-uuid/6c9585d7-bf04-4f3a-8455-a7d025d68c5d";
      fsType = "btrfs";
    };

  fileSystems."/home" =
    {
      device = "/dev/disk/by-uuid/6c9585d7-bf04-4f3a-8455-a7d025d68c5d";
      fsType = "btrfs";
      options = [ "subvol=home" ];
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/A253-A1F7";
      fsType = "vfat";
    };

  fileSystems."/media/gdata2" =
    {
      device = "/dev/disk/by-uuid/b29448d8-fe2b-4b80-8a27-2987665ddde6";
      fsType = "btrfs";
    };

  swapDevices = [ ];
}
