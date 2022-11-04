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
}
