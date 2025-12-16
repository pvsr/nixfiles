{ inputs, ... }:
{
  flake.modules.nixos.desktop =
    { pkgs, ... }:
    {
      imports = [
        inputs.self.modules.nixos.yggdrasil-client
        inputs.srvos.nixosModules.desktop
      ];

      nix.extraOptions = "keep-outputs = true";
      boot.tmp = {
        useTmpfs = true;
        tmpfsSize = "75%";
      };
    };
}
