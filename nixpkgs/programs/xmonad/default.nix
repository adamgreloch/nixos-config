{

  home.packages = with pkgs; [
    feh
    xmobar
  ];

  xsession = {
    enable = true;

    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      extraPackages = hp: [
        hp.dbus
        hp.monad-logger
        hp.xmonad-contrib
      ];
      config = ./xmonad.hs;
    };

  };

  service = {
    unclutter = {
      enable = true;
      timeout = 3;
      threshold = 3;
    };

    random-background = {
      enable = false;
      imageDirectory = "%h/current";
    };

    screen-locker = {
      enable = true;
      lockCmd = "${pkgs.xsecurelock}/bin/xsecurelock";
      inactiveInterval = 15;
      xss-lock.extraOptions = [
        "-l" 
        "-n ${pkgs.xsecurelock}/libexec/xsecurelock/dimmer" 
          #"--ignore-sleep"
        ];
      };
    };
  }
