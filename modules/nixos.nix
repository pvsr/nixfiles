{
  flake.modules.nixos.core =
    {
      config,
      lib,
      pkgs,
      modulesPath,
      ...
    }:
    {
      imports = [ "${modulesPath}/profiles/minimal.nix" ];

      environment.systemPackages = with pkgs; [
        binutils
        coreutils
        curl
        dnsutils
        dosfstools
        file
        iputils
        lsof
        psmisc
        rsync
        utillinux
        ghostty.terminfo
      ];

      time.timeZone = lib.mkDefault "America/New_York";
      networking.nameservers = [
        "1.1.1.1"
        "1.0.0.1"
      ];

      security.sudo.wheelNeedsPassword = false;

      system.rebuild.enableNg = true;

      programs.fish.enable = true;
      programs.fish.useBabelfish = true;
      users.defaultUserShell = pkgs.fish;

      programs.ssh.startAgent = true;

      networking.nftables.enable = true;

      services.fstrim.enable = true;

      systemd.oomd.enableRootSlice = true;
      systemd.oomd.enableUserSlices = true;

      zramSwap = {
        enable = true;
        algorithm = "zstd";
      };
      # https://wiki.archlinux.org/title/Zram#Optimizing_swap_on_zram
      boot.kernel.sysctl = {
        "vm.swappiness" = 180;
        "vm.watermark_boost_factor" = 0;
        "vm.watermark_scale_factor" = 125;
        "vm.page-cluster" = 0;
      };

      # override srvos, needed by btrbk only
      security.sudo.execWheelOnly = lib.mkForce false;

      services.dbus.implementation = "broker";

      virtualisation =
        let
          username = config.local.user.name;
          userCfg = config.users.users.${username};
          variant = {
            nixpkgs.hostPlatform = "x86_64-linux";
            services.tailscale.enable = false;
            users.users.root.hashedPasswordFile = lib.mkForce null;
            users.users.${username} = {
              password = "";
              hashedPasswordFile = lib.mkForce null;
            };
            # https://github.com/NixOS/nixpkgs/issues/6481
            systemd.tmpfiles.rules = [
              "d ${userCfg.home} ${userCfg.homeMode} ${userCfg.name} ${userCfg.group}"
            ];
            virtualisation = {
              cores = 3;
              memorySize = 1024 * 3;
              graphics = false;
            };
          };
        in
        {
          vmVariant = variant;
          vmVariantWithDisko = variant;
        };

      services.openssh = {
        enable = true;
        startWhenNeeded = true;
        listenAddresses = [ { addr = "[::1]"; } ];
      };
    };
}
