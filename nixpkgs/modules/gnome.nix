{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    gnomeExtensions.dash-to-dock
    gnomeExtensions.sound-output-device-chooser
    cinnamon.nemo
  ];

  gtk = {
    enable = true;

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    theme = {
      name = "Adwaita-dark";
      package = pkgs.palenight-theme;
    };
  };

  dconf.settings = {
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [
        "dash-to-dock@micxgx.gmail.com"
        "sound-output-device-chooser@kgshank.net"
      ];
      favourite-apps = [
        "firefox.desktop"
        "nemo.desktop"
        "Alacritty.desktop"
        "org.gnome.Settings.desktop"
        "clion.desktop"
        "idea-ultimate.desktop"
        "org.gnomoe.Evince.desktop"
        "thunderbird.desktop"
        "spotify.desktop"
        "org.gnome.Calculator.desktop"
        "anki.desktop"
      ];
    };
    "org/gnome/shell/extensions/dash-to-dock" = {
      extend-height = true;
      dock-fixed = true;
      dock-position = "LEFT";
      custom-theme-shrink = true;
      background-color = "rgb(0,0,0)";
      dash-max-icon-size = 38;
      transparency-mode = "DYNAMIC";
      customize-alphas = true;
      min-alpha = 0.5;
      max-alpha = 1.0;
      show-trash = false;
      running-indicator-style = "DOTS";
    };
    "org/gnome/desktop/peripherals/keyboard" = {
      delay = lib.hm.gvariant.mkUint32 200;
      repeat-interval = lib.hm.gvariant.mkUint32 30;
    };
    "org/gnome/settings-daemon/plugins/media-keys" = {
      email = ["<Control><Super>m"];
    };
    "org/gnome/desktop/wm/keybindings" = {
      close = ["<Shift><Super>q"];
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      name = "term";
      command = "alacritty";
      binding = "<Shift><Super>Return";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      name = "screenshot to clipboard";
      command = "maim -s -u | xclip -selection clipboard -t image/png";
      binding = "<Shift><Control><Super>s";
    };
  };
}
