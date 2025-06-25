{ self, ... }:
{
  flake.modules.homeManager.ruan =
    { pkgs, ... }:
    {
      imports = [
        self.modules.homeManager.nixos
        self.modules.homeManager.firefox
      ];
    };
}
