{ self, ... }:
{
  flake.modules.homeManager.ruan =
    { pkgs, ... }:
    {
      imports = [ self.modules.homeManager.nixos ];

      home.packages = with pkgs; [ nvtopPackages.amd ];
    };
}
