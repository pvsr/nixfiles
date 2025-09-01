{
  flake.modules.nixos.desktop =
    { pkgs, ... }:
    {
      hardware.bluetooth.enable = true;
      environment.systemPackages = [ pkgs.bluetuith ];
      environment.persistence.nixos.directories = [ "/var/lib/bluetooth" ];
    };
}
