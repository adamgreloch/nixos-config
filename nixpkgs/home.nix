{ config, pkgs, ... }:

# TODO
# * symlink xmobar config and make them machine-specific!

{
  imports = [
    ./programs/xmonad/default.nix
    ./machine.nix # import machine-specific config
  ];

  home.username = "adam";
  home.homeDirectory = "/home/adam";

  home.stateVersion = "22.05";

  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
      anki
      atool

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

      android-studio
      qemu_kvm
      jetbrains.idea-ultimate
      jetbrains.clion
      jdk11

      # math-related
      texlive.combined.scheme-full
      kalker

      # c/cpp
      gcc
      gdb
      gnumake
      valgrind
      subversion

      # for fzf and my zsh binds
      fd
      tree

      s-tui
      stress

      (let
        customRC = ''${builtins.readFile (./programs/vim/vimrc)}'';
        vim = config.programs.vim.packageConfigurable.customize {
          name = "vim";
          vimrcConfig = { inherit customRC; };
        };
      in vim)

      zoom-us
    ];

    programs = {
      alacritty = {
        enable = true;
        settings = {
          window.padding = {
            x = 5;
            y = 5;
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
            name = "Adam Greloch";
            email = "zplhatesbananas@gmail.com";
          };
          core = {
            editor = "vim";
            autocrlf = "input";
          };
          commit.verbose = true;
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
          merge.tool = "vimdiff";
        };
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
        defaultKeymap = "emacs";
        shellAliases = {
          ls = "ls -a --color=auto";
          mv = "mv -v";
          rm = "rm -I";

          g = "git status";
          ga = "git add";
          gc = "git commit";
          gl = "git lg";

          v = "vim";
          vxm = "vim ~/.config/nixpkgs/programs/xmonad/xmonad.hs";
          vxmb = "vim ~/.config/xmobar/xmobarrc";
          shdn = "shutdown now";
          x = "xdg-open";
          z = "zathura";
          zp = "z *.pdf";
          plan = "feh -Z ~/Pudlo/studia/plan.gif";

          sconf = "sudo nixos-rebuild switch";
          shome = "home-manager switch";
          vhome = "vim ~/.config/nixpkgs/home.nix";
          vconf = "vim /etc/nixos/configuration.nix";
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
          "95:class_g = 'Alacritty' && focused"
          "85:class_g = 'Alacritty' && !focused"
          "100:class_g = 'Zathura' && focused"
          "90:class_g = 'Zathura' && !focused"
        ];
        shadow = false;
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

  home.file = {
    ideavimrc = {
      source = ./programs/ideavimrc/.ideavimrc;
      target = ".ideavimrc";
    };
    xmobar = {
      source = ./programs/xmobar;
      target = ".config/xmobar";
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
