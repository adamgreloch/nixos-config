{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    mathematica
  ];

  programs = {
    alacritty.settings = {
      font = {
        normal = {
          family = "Iosevka Extended";
          style = "Regular";
        };
        size = 10;
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
