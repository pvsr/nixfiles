{ self, ... }:
{
  flake.modules.homeManager.ruan =
    { pkgs, ... }:
    {
      imports = [
        self.modules.homeManager.nixos
        self.modules.homeManager.firefox
      ];

      home.packages = with pkgs; [ nvtopPackages.amd ];
    };
}
