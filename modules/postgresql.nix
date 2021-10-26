{ config, pkgs, ... }:
{
  services.postgresql = {
    # enable = true;
    # ensureUsers = [
    #   {
    #     name = "peter";
    #     ensurePermissions = {
    #       "DATABASE miniflux" = "CONNECT";
    #       "SCHEMA public" = "USAGE";
    #       "ALL TABLES IN SCHEMA public" = "SELECT";
    #     };
    #   }
    # ];
  };
}
