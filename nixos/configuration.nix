{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./wm/xmonad.nix
      ./machine.nix # import machine-specific config
  ];

  # Bootloader.
  boot.loader.timeout = 0;

  boot.loader.systemd-boot = {
    enable = true;
    editor = false; # set to true creates vulnerability
  };

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # Switch some keys on Apple Keyboard
  boot.extraModprobeConfig = ''
      # Function/media keys:
      #   0: Function keys only.
      #   1: Media keys by default.
      #   2: Function keys by default.
      options hid_apple fnmode=2
      # Swap Alt key and Command key.
      options hid_apple swap_opt_cmd=1
      # Swap the Fn and left Control keys
      options hid_apple swap_fn_leftctrl=1
    '';

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Warsaw";

  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.utf8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pl_PL.utf8";
    LC_IDENTIFICATION = "pl_PL.utf8";
    LC_MEASUREMENT = "pl_PL.utf8";
    LC_MONETARY = "pl_PL.utf8";
    LC_NAME = "pl_PL.utf8";
    LC_NUMERIC = "pl_PL.utf8";
    LC_PAPER = "pl_PL.utf8";
    LC_TELEPHONE = "pl_PL.utf8";
    LC_TIME = "pl_PL.utf8";
  };

  fonts.fonts = with pkgs; [
    iosevka
    gohufont
  ];

  # Configure keymap in X11
  services.xserver = {
    layout = "pl";
    xkbVariant = "";
	autoRepeatDelay = 200;
    autoRepeatInterval = 30;
    libinput = {
      enable = true;
      touchpad.naturalScrolling = true;
      touchpad.tappingDragLock = false;
    };
  };

  # Enable zsh system-wide and ad it to /etc/shells
  programs.zsh.enable = true;
  environment.shells = with pkgs; [ zsh ];

  # Configure console keymap
  console.keyMap = "pl2";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.adam = {
    isNormalUser = true;
    description = "Adam";
    extraGroups = [ "networkmanager" "wheel" "audio" "video"];
    shell = pkgs.zsh;
  };

  # Turn on automatic nix optimization and garbage collection
  nix = {
    settings.auto-optimise-store = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile
  environment.systemPackages = with pkgs; [
    vim
    networkmanagerapplet
    xsecurelock
  ];

  services = {
      syncthing = {
          enable = true;
          user = "adam";
          dataDir = "/home/adam/sync";    # Default folder for new synced folders
          configDir = "/home/adam/sync/.config";   # Folder for Syncthing's settings and keys
        };
      };

  
  ## Security
  # TODO: whole-disk encryption

  # Open ports in the firewall for Syncthing
  networking.firewall.allowedTCPPorts = [ 22000 ];
  networking.firewall.allowedUDPPorts = [ 22000 21027 ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.xss-lock.enable = true;

  # Set up xsecurelock
  environment.sessionVariables = rec {
    XSECURELOCK_NO_COMPOSITE = "1";
    XSECURELOCK_SHOW_DATETIME = "1";
  };

  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05";
}
