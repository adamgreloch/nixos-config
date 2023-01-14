{ config, pkgs, ... }:

{
  imports = [
    ../modules/gnome.nix
    #../programs/xmonad/default.nix
  ];

  home.packages = [
    (let older_pkgs = import (builtins.fetchGit {
             name = "my-old-revision";                                                 
             url = "https://github.com/nixos/nixpkgs/";                       
             ref = "refs/heads/release-22.05";                     
             rev = "13573c668b9227842920d398839ccae0c39bcf91";
           }) {};          
    in
    # I don't fancy redownloading Mathematica just to upgrade from 13.0.1 to
    # 13.1.0.
    older_pkgs.mathematica)
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
