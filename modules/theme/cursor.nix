{
  flake.modules.nixos.desktop =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.vanilla-dmz ];
      hjem.extraModules = [
        {
          niri.extraConfig = ''
            cursor {
                xcursor-theme "Vanilla-DMZ"
                xcursor-size 32
                hide-when-typing
            }
          '';
        }
      ];
    };
}
