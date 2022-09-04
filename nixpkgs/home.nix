{ config, pkgs, ... }:

{
  home.username = "adam";
  home.homeDirectory = "/home/adam";

  home.stateVersion = "22.05";

  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [

      calibre
      firefox
      dmenu
      pfetch
      spotify
      thunderbird
      xmobar
      feh
      maim
      xclip

      jetbrains.idea-ultimate
      jdk11

      # math-related
      texlive.combined.scheme-full
      mathematica

      # for fzf and my zsh binds
      fd
      tree

      s-tui
      stress
    ];

    programs = {
      alacritty = {
        enable = true;
        settings = {
          window.padding = {
            x = 5;
            y = 5;
          };
          font = {
            normal = {
              family = "Iosevka Extended";
              style = "Regular";
            };
            size = 10;
          };
          colors = {
            primary = {
              background = "0x121212";
              foreground = "0xdedede";
            };
          };
        };
      };

      tmux = {
        enable = true;
        extraConfig = builtins.readFile (./programs/tmux/tmux.conf);
      };

      git = {
        enable = true;
        lfs.enable = true;
        signing = {
          key = "A532872D664CD190";
          signByDefault = true;
        };
        extraConfig = {
          user = {
            user = "Adam Greloch";
            email = "zplhatesbananas@gmail.com";
          };
          core = {
            editor = "vim";
            autocrlf = "input";
          };
          color = {
            ui = true;
          };
          alias = {
            lg = "log --color --graph --pretty=format:'%Cred%h%Creset
            -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'
            --abbrev-commit";
          };
          rebase.autoStash = true;
          status = {
            branch = true;
            short = true;
          };
          pull.rebase = true;
          diff.tool = "vimdiff";
        };
      };

      vim = {
        enable = true;
        extraConfig = builtins.readFile (./programs/vim/vimrc);
      };

      fzf = {
        enable = true;
      };


      zathura = {
        enable = true;
        extraConfig = builtins.readFile (./programs/zathura/zathurarc);
      };

      zsh = {
        enable = true;
        shellAliases = {
          ls = "ls -a --color=auto";
          mv = "mv -v";
          rm = "rm -I";

          v = "vim";
          vxm = "vim ~/.config/nixpkgs/programs/xmonad/xmonad.hs";
          vxmb = "vim ~/.config/xmobar/xmobarrc";
          shdn = "shutdown now";
          x = "xdg-open";
          z = "zathura";
          zp = "z *.pdf";

          sconf = "sudo nixos-rebuild switch";
          shome = "home-manager switch";
          vhome = "vim ~/.config/nixpkgs/home.nix";
          vconf = "sudo vim /etc/nixos/configuration.nix";
          cdpkg = "cd ~/.config/nixpkgs/";

          tl = "vim ~/Pudlo/thelist.md";
        };
        history = {
          size = 5000;
          path = "${config.xdg.dataHome}/zsh/history";
        };
        initExtra = builtins.readFile (./programs/zsh/additional);
      };
    };

    services = {
      picom = {
        enable = true;
        backend = "glx";
        vSync = true;
        fade = true;
        fadeDelta = 4;
        opacityRule = [
          "100:class_g = 'Alacritty' && focused"
          "85:class_g = 'Alacritty' && !focused"
          "100:class_g = 'Zathura' && focused"
          "90:class_g = 'Zathura' && !focused"
        ];
        shadow = true;
        shadowOpacity = "0.75"; # TODO Dont shadow menus
        extraOptions = "use-damage = false";
      };

      redshift = {
        enable = true;
        latitude = 52.14;
        longitude = 21.1;
      };

      random-background = {
        enable = true;
        imageDirectory = "%h/wallpapers";
      };

      screen-locker = {
          enable = true;
          lockCmd = "${pkgs.xsecurelock}/bin/xsecurelock";
          xss-lock.extraOptions = [ "-l" 
          "-n ${pkgs.xsecurelock}/libexec/xsecurelock/dimmer" ];
        };

      unclutter = {
        enable = true;
        timeout = 3;
        threshold = 3;
      };
    };

  home.pointerCursor = {
    name = "Vanilla-DMZ-AA";
    package = "${pkgs.vanilla-dmz}";
    size = 16;
    x11 = {
      enable = true;
      defaultCursor = "left_ptr";
    };
  };

  imports = [
    ./programs/xmonad/default.nix
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}