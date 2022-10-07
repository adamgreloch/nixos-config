{ config, lib, pkgs, ... }:

{
  networking.hostName = "nixos-t480";

  boot.initrd.availableKernelModules = [ "aesni_intel" "cryptd" "xhci_pci" "nvme" "usb_storage"
  "sd_mod" "thinkpad_acpi"];
  boot.initrd.kernelModules = [ "acpi_call" ];
  boot.extraModulePackages = with config.boot.kernelPackages; [acpi_call];

  hardware.acpilight.enable = true;

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "powersave";
    powertop.enable = true;
  };

  services = {
    tlp = {
      enable = true;
      settings = {
        START_CHARGE_THRESH_BAT0 = 70;
        START_CHARGE_THRESH_BAT1 = 70;
        STOP_CHARGE_THRESH_BAT0 = 80;
        STOP_CHARGE_THRESH_BAT1 = 80;
        DEVICES_TO_DISABLE_ON_STARTUP="bluetooth";
      };
    };
    throttled.enable = true;

    undervolt = {
      enable = true;
      coreOffset = -90;
      gpuOffset = -40;
    };

    logind.extraConfig = ''
      # Suspend on short press
      HandlePowerKey=suspend
    '';
  };

  # Enable TPM 2.0
  security.tpm2.enable = true;

  boot.resumeDevice = "/dev/disk/by-uuid/a04b6bb1-8ef5-4571-852a-932d9ed524bb";

  boot.kernelParams = [ "resume_offset=14196736" ];

  swapDevices = [{device = "/var/swapfile"; size = 32768; }];
}
			
