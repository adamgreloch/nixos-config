{ config, pkgs, ... }:

{
  imports = [
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
    maim
    xclip

    android-studio
    qemu_kvm
    jetbrains.idea-ultimate
    jdk11

    jetbrains.clion
    jetbrains.datagrip
    jetbrains.pycharm-professional

    # math-related
    texlive.combined.scheme-full
    kalker

    # rails
    jetbrains.ruby-mine
    ruby_3_0

    # c/cpp
    gcc
    gdb
    gnumake
    cmake
    valgrind
    subversion

    # for fzf and my zsh binds
    fd
    tree

    fortune

    python39
    pandoc

    s-tui
    stress

    (let
      customRC = ''${builtins.readFile (./programs/vim/vimrc)}'';
      vim = config.programs.vim.packageConfigurable.customize {
        name = "vim";
        vimrcConfig = { inherit customRC; };
      };
    in vim)

    man-pages
    libreoffice

    xournalpp
    xfce.thunar
    vlc
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

    direnv = {
      enable = true;
      nix-direnv.enable = true;
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
          gd = "git diff";

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
        enable = false;
        backend = "glx";
        vSync = true;
        fade = true;
        fadeDelta = 4;
        opacityRules = [
          "95:class_g = 'Alacritty' && focused"
          "85:class_g = 'Alacritty' && !focused"
        ];
        shadow = false;
        shadowOpacity = "0.75"; # TODO Dont shadow menus
        settings = "use-damage = false;";
      };

      redshift = {
        enable = true;
        latitude = 52.14;
        longitude = 21.1;
      };

      sxhkd = {
        enable = true;
        keybindings = {
          "super + shift + ctrl + p"
          = "zathura \"$(fd -I -e \"pdf\" -e \"djvu\" | dmenu -i -l 30)\"";
          "super + shift + ctrl + f"
          = "alacritty -e vim \"$(fd | dmenu -i -l 30)\"";
          "super + shift + Return" = "alacritty";
          "super + p" = "dmenu_run";
          "super + ctrl + t" = "thunderbird";
        };
      };
    };

    systemd.user.services = {
      sxhkd = {
        Service = {
          ExecStart = ''
            ${pkgs.sxhkd}/bin/sxhkd
          '';
         # ExecReload = ''
         #   /bin/pkill sxhkd
         # '';
      };
      Install = {
        WantedBy = [ "display-manager.service" ];
      };
    };
    hsetroot = {
      Service = {
        Type = "oneshot";
        ExecStart = ''
            ${pkgs.hsetroot}/bin/hsetroot -solid "#1d2129"
        '';
      };
      Install = {
        WantedBy = [ "picom.service" ];
      };
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

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  home.sessionVariables = {
    GTK_THEME = "adwaita-dark";
  };

  home.file = {
    ideavimrc = {
      source = ./programs/ideavimrc/.ideavimrc;
      target = ".ideavimrc";
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
