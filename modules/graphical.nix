{ pkgs, usePipewire ? false, ... }:
{
  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;

  hardware.pulseaudio.enable = !usePipewire;
  hardware.bluetooth.enable = usePipewire;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = usePipewire;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # config.pipewire = {
    # };
    media-session.config.bluez-monitor.rules = [
      {
        # Matches all cards
        matches = [{ "device.name" = "~bluez_card.*"; }];
        actions = {
          "update-props" = {
            "bluez5.auto-connect" = [ "hfp_hf" "hsp_hs" "a2dp_sink" ];
          };
        };
      }
      {
        matches = [
          # Matches all sources
          { "node.name" = "~bluez_input.*"; }
          # Matches all outputs
          { "node.name" = "~bluez_output.*"; }
        ];
        actions = {
          "node.pause-on-idle" = false;
        };
      }
      {
        matches = [{ "device.name" = "bluez_card.02:AE:0B:08:BE:87"; }];
        actions = {
          "update-props" = {
            "bluez5.auto-connect" = [ "hfp_ag" "hsp_ag" "a2dp_source" ];
            "bluez5.a2dp-source-role" = "input";
          };
        };
      }
    ];
  };

  boot.tmpOnTmpfs = true;

  security.sudo.wheelNeedsPassword = false;

  fonts = {
    enableDefaultFonts = true;
    fonts = with pkgs; [
      dejavu_fonts
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      libertinus
      iosevka
      sarasa-gothic
      font-awesome
      fantasque-sans-mono
    ];
    fontconfig.defaultFonts = {
      monospace = [ "DejaVu Sans Mono" ];
      sansSerif = [ "DejaVu Sans" ];
    };
  };

  environment = {
    sessionVariables = {
      #QT_QPA_PLATFORMTHEME = "gtk2";
    };

    systemPackages = with pkgs; [
      #cursor
      feh
      pulsemixer
    ];
  };
}
