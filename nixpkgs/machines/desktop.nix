{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    zoom-us
  ];

  programs = {
    alacritty.settings = {
      font = {
        normal = {
          family = "Iosevka Extended";
          style = "Regular";
        };
        size = 13;
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
