{
  config.flake.modules.nixos.core =
    { config, lib, ... }:
    let
      cfg = config.local.user;
    in
    {
      options.local.user = {
        name = lib.mkOption {
          default = "peter";
          readOnly = true;
        };
        extraGroups = lib.mkOption {
          type = with lib.types; listOf str;
          default = [ ];
          apply = groups: [ "wheel" ] ++ groups;
        };
      };

      config.users.users.${cfg.name} = {
        uid = 1000;
        isNormalUser = true;
        inherit (cfg) extraGroups;
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILACfyJt7+ULfX1XFhBbztlTMNDZnRNQbKj5DV2S7uVo peter@grancel"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ9oTGdaddqjAM93FQP83XABhVxZo1jo8ljb62CtUoBq peter@ruan"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKzIvu2+Spcxq92BYAAbfn4wHhgf/p+3P3ntaaLsR9UH peter@crossbell"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIObxXM22QQwNosuoH9UXhJWAm5PQOMtxEHGI3ElhsdCn peter@arseille"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJojCQs1VjUFaO/2dOq2N/zQgfRtBtFE7nLu3VpJZkwt price@jurai"
        ];
      };
    };
}
