{ config, lib, pkgs, ... }:

{
  imports = [
    ../wm/gnome.nix
  ];

  networking.hostName = "nixos-desktop";
}
			
