{ self, inputs, ... }:
{
  flake.darwinConfigurations.jurai = inputs.nix-darwin.lib.darwinSystem {
    modules = [ self.modules.darwin.default ];
  };

  flake.modules.darwin.default =
    { pkgs, ... }:
    {
      local.user.name = "price";
      nix.enable = false;
      security.pki.installCACerts = false;
      system.keyboard.enableKeyMapping = true;
      system.keyboard.remapCapsLockToControl = true;
      system.startup.chime = false;
      system.stateVersion = 6;
      nixpkgs.hostPlatform = "aarch64-darwin";
      hjem.extraModules = [ self.modules.hjem.macbook ];
    };

  flake.modules.hjem.macbook =
    { pkgs, ... }:
    {
      directory = "/Users/price";

      packages = with pkgs; [
        uutils-coreutils-noprefix
        sarasa-gothic
        fantasque-sans-mono
      ];

      xdg.config.files."git/config".value.user.email = "price@hubspot.com";
      xdg.config.files."jj/config.toml".value.user.email = "price@hubspot.com";
    };
}
