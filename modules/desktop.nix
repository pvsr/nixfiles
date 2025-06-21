{ inputs, ... }:
{
  flake.modules.nixos.desktop =
    { pkgs, ... }:
    {
      imports = [
        inputs.srvos.nixosModules.desktop
      ];

      environment.systemPackages = with pkgs; [
        man-pages
      ];

      nix.extraOptions = "keep-outputs = true";
      boot.tmp = {
        useTmpfs = true;
        tmpfsSize = "75%";
      };
    };
}
