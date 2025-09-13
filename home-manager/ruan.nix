{ self, ... }:
{
  flake.modules.homeManager.ruan =
    { pkgs, ... }:
    {
      imports = [
        self.modules.homeManager.desktop
        self.modules.homeManager.firefox
      ];
    };
}
