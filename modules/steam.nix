{ config, lib, ... }:
{
  config = lib.mkIf config.programs.steam.enable {
    home-manager.users.peter.programs.fish.functions =
      builtins.mapAttrs (n: id: "steam steam://rungameid/${id}")
        {
          "hoi4" = "394360";
          "eu4" = "236850";
          "ck3" = "1158310";
          "vic3" = "529340";
          "bg3" = "1086940";
          "p5r" = "1687950";
        };
  };
}
