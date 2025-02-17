{ self, ... }:
{
  flake.modules.homeManager.jurai.imports = [ self.modules.homeManager.desktop ];
  flake.modules.homeManager.jurai.programs.niri.settings.outputs."winit".scale = 2.0;

  local.homeConfigurations.jurai = self.modules.homeManager.macbook;
  flake.modules.homeManager.macbook =
    { pkgs, ... }:
    {
      home = {
        username = "price";
        homeDirectory = "/Users/price";
      };

      home.packages = with pkgs; [
        uutils-coreutils-noprefix
        sarasa-gothic
        fantasque-sans-mono
      ];

      programs.git.userEmail = "price@hubspot.com";
      programs.jujutsu.settings.user.email = "price@hubspot.com";
      programs.tmux.terminal = "screen-256color";
    };
}
