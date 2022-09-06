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
}
