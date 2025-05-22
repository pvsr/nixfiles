{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.local.gnome.enable = lib.mkEnableOption { };

  config = lib.mkIf config.local.gnome.enable {
    services.xserver.desktopManager.gnome.enable = true;
    environment.gnome.excludePackages = with pkgs; [
      orca
      evince
      file-roller
      geary
      gnome-disk-utility
      seahorse
      sushi
      # sysprof
      #
      # adwaita-icon-theme
      # nixos-background-info
      # gnome-backgrounds
      gnome-bluetooth
      gnome-color-manager
      # gnome-control-center
      gnome-shell-extensions
      gnome-tour
      gnome-user-docs
      # glib
      # gnome-menus
      # gtk3.out # for gtk-launch program
      # xdg-user-dirs
      # xdg-user-dirs-gtk
      #
      baobab
      epiphany
      gnome-text-editor
      gnome-calculator
      gnome-calendar
      # gnome-characters
      gnome-clocks
      gnome-console
      gnome-contacts
      gnome-font-viewer
      gnome-logs
      gnome-maps
      gnome-music
      gnome-system-monitor
      # gnome-weather
      loupe
      nautilus
      gnome-connections
      simple-scan
      snapshot
      totem
      yelp
      gnome-software
    ];
  };
}
