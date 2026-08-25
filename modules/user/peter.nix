{ lib, ... }:
let
  options.local.username = lib.mkOption {
    type = lib.types.str;
    default = "peter";
  };
  openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILACfyJt7+ULfX1XFhBbztlTMNDZnRNQbKj5DV2S7uVo peter@grancel"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ9oTGdaddqjAM93FQP83XABhVxZo1jo8ljb62CtUoBq peter@ruan"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKJXTjmM8sqYI1WlQJZOpoUfuN3WCGWF5CND8SySuT9O peter@crossbell"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJEGqc+lTGfxD0iIXaI44Mjf2uc08QP/Dql2g/yZKuYV peter@arseille"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJojCQs1VjUFaO/2dOq2N/zQgfRtBtFE7nLu3VpJZkwt price@jurai"
  ];
  aliasModule =
    { config, ... }:
    {
      imports = [
        (lib.mkAliasOptionModule
          [
            "local"
            "user"
          ]
          [
            "users"
            "users"
            config.local.username
          ]
        )
      ];
    };

in
{
  config.flake.modules.nixos.user = {
    imports = [
      { inherit options; }
      aliasModule
    ];
    local.user = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      inherit openssh;
    };
  };

  config.flake.modules.darwin.default = { config, ... }: {
    imports = [
      { inherit options; }
      aliasModule
    ];
    system.primaryUser = config.local.username;
    local.user = { inherit openssh; };
  };
}
