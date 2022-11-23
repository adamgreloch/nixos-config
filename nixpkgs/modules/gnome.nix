{ config, pkgs, lib, ... }:

{
  home.packages = (with pkgs; [
    cinnamon.nemo
  ]) ++ (with pkgs.gnomeExtensions; [
    dash-to-dock
    sound-output-device-chooser
  ]);

  gtk = {
    enable = true;

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
  };

  dconf.settings = {
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [
        "dash-to-dock@micxgx.gmail.com"
        "sound-output-device-chooser@kgshank.net"
      ];
      favorite-apps = [
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
      #extend-height = true;
      dock-fixed = false;
      intellihide = true;
      #dock-position = "LEFT";
      dock-position = "BOTTOM";
      custom-theme-shrink = true;
      background-color = "rgb(0,0,0)";
      dash-max-icon-size = 48;
      transparency-mode = "DYNAMIC";
      customize-alphas = true;
      min-alpha = 0.5;
      max-alpha = 1.0;
      show-trash = false;
      running-indicator-style = "DOTS";
    };
    "org/gnome/desktop/peripherals/keyboard" = {
      delay = lib.hm.gvariant.mkUint32 150;
      repeat-interval = lib.hm.gvariant.mkUint32 30;
    };
    "org/gnome/desktop/peripherals/touchpad" = {
      tap-to-click = true;
    };
    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,maximize,close";
    };
    "org/gnome/desktop/interface" = {
      enable-hot-corners = false;
      show-battery-percentage = true;
    };
  };
}
