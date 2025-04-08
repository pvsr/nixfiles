{ lib, ... }:
{
  flake.modules.nixos.desktop =
    { config, pkgs, ... }:
    {
      config = lib.mkIf config.hardware.bluetooth.enable {
        environment.systemPackages = [ pkgs.bluetuith ];
        environment.persistence.nixos.directories = [ "/var/lib/bluetooth" ];
        systemd.user.services.mpris-proxy = {
          unitConfig = {
            Description = "Proxy Bluetooth Controls via MPRIS";
            BindsTo = [ "bluetooth.target" ];
            After = [ "bluetooth.target" ];
          };
          wantedBy = [ "bluetooth.target" ];
          serviceConfig = {
            Type = "simple";
            ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
          };
        };
      };
    };
}
