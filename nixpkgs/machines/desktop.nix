{ config, pkgs, ... }:

{
  imports = [
    #./programs/xmonad/default.nix
    ../modules/gnome.nix
  ];

  home.packages = with pkgs; [
    zoom-us
    libreoffice
  ];

  programs = {
    alacritty.settings = {
      font = {
        normal = { family = "Ubuntu Mono";
          style = "Regular";
        };
        size = 14;
      };
    };
  };

  home.file = {
    xmobar = {
      source = ../programs/xmobar/desktop;
      target = ".config/xmobar";
    };
  };
}
