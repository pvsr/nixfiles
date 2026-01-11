{ self, ... }:
{
  flake.modules.hjem.grancel =
    { pkgs, ... }:
    {
      imports = [
        self.modules.hjem.desktop
        self.modules.hjem.firefox
      ];

      packages = with pkgs; [
        (prismlauncher.override { jdks = [ jdk ]; })
        (spotifyd.override { withMpris = true; })
        sptlrx
      ];

      niri.extraConfig = ''output "HDMI-A-2" { variable-refresh-rate; }'';

      systemd.services.mpris-proxy = {
        unitConfig = {
          Description = "Proxy forwarding Bluetooth MIDI controls via MPRIS2 to control media players";
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
}
