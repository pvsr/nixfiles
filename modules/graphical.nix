{pkgs, ...}: {
  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  services.earlyoom.enable = true;

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
      monospace = ["DejaVu Sans Mono"];
      sansSerif = ["DejaVu Sans"];
    };
  };

  environment = {
    sessionVariables = {
      PAGER = "less";
      LESS = "-iFJMRWX -z-4 -x4";
    };

    systemPackages = with pkgs; [
      #cursor
      feh
      pulsemixer
      man-pages
    ];
  };

  documentation.dev.enable = true;
}
