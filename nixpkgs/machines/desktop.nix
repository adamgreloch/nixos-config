{ config, pkgs, ... }:

{
    home.packages = with pkgs; [
    ];

    programs = {
      alacritty.settings = {
          font = {
            normal = {
              family = "Iosevka Extended";
              style = "Regular";
            };
            size = 14;
          };
      };
    };
}
