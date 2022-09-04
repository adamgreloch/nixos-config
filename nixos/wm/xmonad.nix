{ config, lib, pkgs, ... }:

{
	services = {
		upower.enable = true; # check if needed
        dbus.enable = true;
        gnome.gnome-keyring.enable = true;

		xserver = {
			enable = true;
            displayManager = {
              gdm.enable = true;
              defaultSession = "none+xmonad";
            };

			windowManager.xmonad = {
				enable = true;
				enableContribAndExtras = true;
			};
		};
	};
}
			
