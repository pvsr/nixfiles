{ config, ... }:
let
  hosts = builtins.attrNames config.flake.nixosConfigurations;
in
{
  flake.modules.nixos.core =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        (pkgs.writers.writeFishBin "deploy" (builtins.readFile ./deploy.fish))
      ];
    };

  flake.modules.hjem.core = {
    fish.interactiveShellInit = # fish
      ''
        set commands build switch boot test dry-build dry-activate
        complete --command deploy -f -a "$commands"
        complete --command deploy -s R -l remote
        complete --command deploy -s c -l command -x \
         -a "${(builtins.concatStringsSep " " hosts)}"
        complete --command deploy -s r -l revision -x \
         -a "(COMPLETE=fish jj -- jj show ' ' | string trim)"
      '';
  };
}
