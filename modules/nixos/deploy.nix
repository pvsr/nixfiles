{ config, ... }:
let
  hosts = config.flake.nixosConfigurations;
  hostnames = builtins.attrNames hosts;
  inherit (hosts.grancel.config.networking) domain fqdn;

in
{
  flake.modules.nixos.core =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        (pkgs.writers.writeFishBin "deploy" (
          ''
            set grancel ${fqdn}
            set domain ${domain}
          ''
          + builtins.readFile ./deploy.fish
        ))
      ];
    };

  flake.modules.hjem.core.fish.interactiveShellInit = # fish
    ''
      complete -c deploy -s R -l remote
      set commands build switch boot test dry-build dry-activate
      complete -c deploy -s c -l command -x -a "$commands"
      complete -c deploy -s r -l revision -x \
       -a "(COMPLETE=fish jj -- jj show ' ' | string trim)"
      complete -c deploy -f -a "${(builtins.concatStringsSep " " hostnames)}"
    '';
}
