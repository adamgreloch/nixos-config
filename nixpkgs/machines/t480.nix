{ config, pkgs, ... }:

{
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
        size = 11;
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
