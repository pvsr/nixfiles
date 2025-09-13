{
  flake.modules.homeManager.core.programs.fish.shellAbbrs =
    builtins.mapAttrs
      (_: replacement: {
        position = "anywhere";
        expansion = replacement;
      })
      {
        suod = "sudo";
        shwo = "show";
        hsow = "show";
        conifg = "config";
        eanble = "enable";
        udpate = "update";
      };
}
