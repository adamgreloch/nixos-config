{ config, pkgs, ... }:

{
  imports = [
    ../modules/gnome.nix
    #../programs/xmonad/default.nix
  ];

  home.packages = with pkgs; [
    mathematica
  ];

  programs = {
    alacritty.settings = {
      font = {
        normal = {
          family = "Ubuntu Mono";
          style = "Regular";
        };
        size = 14;
      };
    };
  };

  home.file = {
    xmobar = {
      source = ../programs/xmobar/t480;
      target = ".config/xmobar";
    };
  };
}
