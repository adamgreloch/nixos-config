{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    xsecurelock
  ];

  programs.xss-lock.enable = true;

  # Set up xsecurelock
  environment.sessionVariables = rec {
    XSECURELOCK_NO_COMPOSITE = "1";
    XSECURELOCK_SHOW_DATETIME = "1";
  };

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
			
