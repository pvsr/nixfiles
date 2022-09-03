{
  config,
  lib,
  pkgs,
  ...
}: {
  environment.variables = {
    PAGER = "less";
    LESS = "-iFJMRWX -z-4 -x4";
  };

  nix = {
    settings = {
      auto-optimise-store = true;
      sandbox = true;
      allowed-users = ["@wheel"];
      trusted-users = ["root" "@wheel"];
    };
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
}
