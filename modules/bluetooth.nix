{
  pkgs,
  ...
}: {
  hardware.bluetooth.enable = true;
  environment.systemPackages = [
    pkgs.bluetuith
  ];
  environment.etc = {
    "wireplumber/bluetooth.lua.d/51-bluez-config.lua".text = ''
      bluez_monitor.properties = {
        ["bluez5.enable-sbc-xq"] = true,
        ["bluez5.enable-msbc"] = true,
        ["bluez5.enable-hw-volume"] = true,
        ["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
      }
      bluez_monitor.rules = {
        matches = {
          {
            { "device.name", "matches", "bluez_card.*" },
          },
        },
        apply_properties = {
          ["bluez5.auto-connect"] = "[ hfp_hf hsp_hs a2dp_sink ]"
        }
      }
    '';
  };
}
