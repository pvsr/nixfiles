{ inputs, ... }: {
  flake.modules.hjem.core = { pkgs, ... }: {
    imports = [ inputs.noctalia.hjemModules.default ];
    programs.noctalia = {
      enable = true;
      systemd.enable = true;
      package = pkgs.noctalia;
    };
  };
}
