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

  boot.tmp = {
    useTmpfs = true;
    tmpfsSize = "75%";
  };

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
  nix.extraOptions = "keep-outputs = true";

  # srcery
  console.colors = [
    "1c1b19"
    "ef2f27"
    "519f50"
    "fbb829"
    "2c78bf"
    "e02c6d"
    "0aaeb3"
    "baa67f"
    "918175"
    "f75341"
    "98bc37"
    "fed06e"
    "68a8e4"
    "ff5c8f"
    "2be4d0"
    "fce8c3"
  ];
}
