{ inputs, withSystem, ... }:
{
  flake.nixOnDroidConfigurations.default = withSystem "aarch64-linux" (
    { system, pkgs, ... }:
    inputs.nix-on-droid.lib.nixOnDroidConfiguration {
      pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = pkgs.overlays ++ [
          inputs.nix-on-droid.overlays.default
        ];
      };
      modules = [
        inputs.self.modules.nixOnDroid.base
        inputs.self.modules.nixOnDroid.arseille
      ];
    }
  );

  flake.modules.nixOnDroid.arseille =
    { pkgs, ... }:
    {
      system.stateVersion = "24.05";
      time.timeZone = "America/New_York";
      user.shell = "${pkgs.fish}/bin/fish";

      environment.packages = with pkgs; [
        binutils
        coreutils
        curl
        dnsutils
        dosfstools
        file
        iputils
        lsof
        psmisc
        util-linux

        openssh
        which
        gnused
        gawk
        rsync

        fd
        ripgrep
        git
        jujutsu
        helix
        zellij
        (ranger.override {
          imagePreviewSupport = false;
          sixelPreviewSupport = false;
        })
      ];
    };
}
