{ lib, ... }:
let
  options.name = lib.mkOption {
    type = lib.types.str;
    default = "peter";
  };
  openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILACfyJt7+ULfX1XFhBbztlTMNDZnRNQbKj5DV2S7uVo peter@grancel"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ9oTGdaddqjAM93FQP83XABhVxZo1jo8ljb62CtUoBq peter@ruan"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKJXTjmM8sqYI1WlQJZOpoUfuN3WCGWF5CND8SySuT9O peter@crossbell"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIObxXM22QQwNosuoH9UXhJWAm5PQOMtxEHGI3ElhsdCn peter@arseille"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJojCQs1VjUFaO/2dOq2N/zQgfRtBtFE7nLu3VpJZkwt price@jurai"
  ];
in
{
  config.flake.modules.nixos.user =
    { config, ... }:
    let
      cfg = config.local.user;
    in
    {
      options.local.user = {
        inherit (options) name;
        extraGroups = lib.mkOption {
          type = with lib.types; listOf str;
          default = [ ];
          apply = groups: [ "wheel" ] ++ groups;
        };
      };

      config.users.users.${cfg.name} = {
        isNormalUser = true;
        inherit (cfg) extraGroups;
        inherit openssh;
      };
    };

  config.flake.modules.darwin.default =
    { config, ... }:
    let
      cfg = config.local.user;
    in
    {
      options.local.user = { inherit (options) name; };
      config.users.users.${cfg.name} = { inherit openssh; };
    };
}
