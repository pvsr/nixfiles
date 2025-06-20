{
  flake.modules.nixos.core =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        (pkgs.writeScriptBin "deploy" (builtins.readFile ./deploy.fish))
      ];
    };
}
