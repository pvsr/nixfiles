{ inputs, ... }:
let
  inherit (inputs.evergarden.lib.palette) summer winter;
in
{
  flake.modules.hjem.core.programs.noctalia.customPalettes.evergarden-winter-pink = {
    dark = with winter; {
      mPrimary = "#${pink}";
      mOnPrimary = "#${base}";
      mSecondary = "#${orange}";
      mOnSecondary = "#${base}";
      mTertiary = "#${aqua}";
      mOnTertiary = "#${base}";
      mError = "#${red}";
      mOnError = "#${base}";
      mSurface = "#${base}";
      mOnSurface = "#${text}";
      mSurfaceVariant = "#${surface0}";
      mOnSurfaceVariant = "#${subtext0}";
      mOutline = "#${overlay0}";
      mShadow = "#${crust}";
      mHover = "#${surface1}";
      mOnHover = "#${text}";
      terminal = {
        normal = {
          black = "#${surface1}";
          red = "#${red}";
          green = "#${green}";
          yellow = "#${yellow}";
          blue = "#${blue}";
          magenta = "#${pink}";
          cyan = "#${aqua}";
          white = "#${subtext1}";
        };
        bright = {
          black = "#${surface2}";
          red = "#${red}";
          green = "#${green}";
          yellow = "#${yellow}";
          blue = "#${blue}";
          magenta = "#${pink}";
          cyan = "#${aqua}";
          white = "#${subtext0}";
        };
        foreground = "#${text}";
        background = "#${base}";
        selectionFg = "#${text}";
        selectionBg = "#${surface2}";
        cursorText = "#${base}";
        cursor = "#${cherry}";
      };
    };
    light = with summer; {
      mPrimary = "#${pink}";
      mOnPrimary = "#${base}";
      mSecondary = "#${orange}";
      mOnSecondary = "#${base}";
      mTertiary = "#${aqua}";
      mOnTertiary = "#${base}";
      mError = "#${red}";
      mOnError = "#${base}";
      mSurface = "#${base}";
      mOnSurface = "#${text}";
      mSurfaceVariant = "#${surface0}";
      mOnSurfaceVariant = "#${subtext0}";
      mOutline = "#${overlay0}";
      mShadow = "#${crust}";
      mHover = "#${surface1}";
      mOnHover = "#${text}";
      terminal = {
        normal = {
          black = "#${subtext1}";
          red = "#${red}";
          green = "#${green}";
          yellow = "#${yellow}";
          blue = "#${blue}";
          magenta = "#${pink}";
          cyan = "#${aqua}";
          white = "#${surface2}";
        };
        bright = {
          black = "#${subtext0}";
          red = "#${red}";
          green = "#${green}";
          yellow = "#${yellow}";
          blue = "#${blue}";
          magenta = "#${pink}";
          cyan = "#${aqua}";
          white = "#${surface1}";
        };
        foreground = "#${text}";
        background = "#${base}";
        selectionFg = "#${text}";
        selectionBg = "#${surface2}";
        cursorText = "#${base}";
        cursor = "#${cherry}";
      };
    };
  };
}
