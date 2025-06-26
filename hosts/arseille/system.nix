{
  flake.modules.nixOnDroid.arseille =
    { pkgs, ... }:
    {
      system.stateVersion = "24.05";
      time.timeZone = "America/New_York";
      user.shell = "${pkgs.fish}/bin/fish";

      nix.extraOptions = ''
        experimental-features = nix-command flakes
      '';

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
        utillinux

        openssh
        which
        gnused
        gawk
        rsync
      ];

      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
      };
    };
}
