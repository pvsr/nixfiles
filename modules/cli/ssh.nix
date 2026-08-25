{ lib, ... }: {
  flake.modules.hjem.core = { config, ... }: {
    options.ssh.config = lib.mkOption {
      type = lib.types.lines;
    };

    config.files = {
      ".ssh/config" = {
        text = ''
          AddKeysToAgent yes

          Include ssh_config.d/*.conf
        '';
        clobber = false;
      };
      ".ssh/ssh_config.d/hjem.conf".text = config.ssh.config;
    };
  };
}
