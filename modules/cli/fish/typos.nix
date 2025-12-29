{ lib, ... }:
{
  flake.modules.hjem.core.fish.interactiveShellInit =
    lib.concatMapAttrsStringSep "\n" (typo: fix: "abbr --add --position anywhere -- ${typo} ${fix}")
      {
        suod = "sudo";
        shwo = "show";
        hsow = "show";
        conifg = "config";
        eanble = "enable";
        udpate = "update";
      };
}
