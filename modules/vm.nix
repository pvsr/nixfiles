{
  flake.modules.nixos.core =
    { config, lib, ... }:
    let
      username = config.local.user.name;
      userCfg = config.users.users.${username};
      vmVariant = {
        nixpkgs.hostPlatform = "x86_64-linux";
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
      virtualisation = {
        inherit vmVariant;
        vmVariantWithDisko = vmVariant;
      };
    };
}
