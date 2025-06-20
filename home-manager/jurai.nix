{ self, ... }:
{
  flake.modules.homeManager.jurai.imports = [ self.modules.homeManager.nixos ];

  flake.modules.homeManager.macbook =
    { pkgs, ... }:
    {
      imports = [ self.modules.homeManager.core ];

      home = {
        username = "price";
        homeDirectory = "/Users/price";
        stateVersion = "24.05";
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
