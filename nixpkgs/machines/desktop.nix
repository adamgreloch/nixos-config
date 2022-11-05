{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    zoom-us
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
      source = ../programs/xmobar/desktop;
      target = ".config/xmobar";
    };
  };
}
