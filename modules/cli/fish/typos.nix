{ lib, ... }:
{
  flake.modules.hjem.core.fish.interactiveShellInit =
    lib.concatMapAttrsStringSep "\n" (typo: fix: "abbr --add --position anywhere -- ${typo} ${fix}")
      {
        suod = "sudo";
        shwo = "show";
        hsow = "show";
        hlep = "help";
        conifg = "config";
        eanble = "enable";
        udpate = "update";
      };
}
