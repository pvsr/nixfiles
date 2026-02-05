{ config, ... }:
{
  flake.modules.hjem.desktop =
    { lib, pkgs, ... }:
    {
      packages = [ pkgs.ghostty ];
      xdg.config.files."ghostty/config".text = ''
        theme = light:Rose Pine Dawn,dark:Srcery
        command = fish
        font-family = ${config.local.appFont}
        font-size = 16
        cursor-style-blink = false
        shell-integration-features = no-cursor
        mouse-hide-while-typing = true
        gtk-single-instance = true
        confirm-close-surface = false
        quit-after-last-window-closed = true
        window-padding-balance = true
        window-padding-color = extend
        window-padding-x = 0
        window-padding-y = 0
        window-step-resize = true
        keybind = ctrl+[=text:\x1b
        keybind = ctrl+j=text:\r
        keybind = ctrl+m=text:\r
        keybind = alt+f4=unbind
        keybind = ctrl+shift+q=unbind
        keybind = ctrl+shift+w=unbind
        keybind = ctrl+enter=unbind
        keybind = alt+1=unbind
        keybind = alt+2=unbind
        keybind = alt+3=unbind
        keybind = alt+4=unbind
        keybind = alt+5=unbind
        keybind = alt+6=unbind
        keybind = alt+7=unbind
        keybind = alt+8=unbind
        keybind = alt+9=unbind
        keybind = alt+0=unbind
      '';
    };

  flake.modules.nixos.core =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.ghostty.terminfo ];
    };
  flake.modules.nixos.container =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.ghostty.terminfo ];
    };
}
