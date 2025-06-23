{ self, ... }:
{
  local.homeConfigurations.valleria = self.modules.homeManager.valleria;

  flake.modules.homeManager.valleria =
    { pkgs, ... }:
    {
      imports = [
        self.modules.homeManager.desktop
        self.modules.homeManager.firefox
      ];

      home.username = "peter";
      home.homeDirectory = "/home/peter";

      home.packages = with pkgs; [
        nvtopPackages.amd
      ];

      programs.firefox.package = null;

      services.mpris-proxy.enable = true;
    };
}
