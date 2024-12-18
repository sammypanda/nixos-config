# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-label/root";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-label/BOOT";
      fsType = "vfat";
    };
  
  fileSystems."/home/sammy/Storage" =
    { device = "/dev/disk/by-label/storage";
      fsType = "ext4";
    };

  fileSystems."/home/sammy/Speedy" =
    { device = "/dev/disk/by-label/speedy";
      fsType = "ext4";
    };

  fileSystems."/home/sammy/StorageBack" =
    { device = "/dev/disk/by-label/storageback";
      fsType = "ext4";
    };

  fileSystems."/export/nfs" = {
    device = "/mnt/nfs";
    options = [ "bind" ];
  };

  # NFS server
  services.nfs.server.enable = true;
  services.nfs.server.exports = ''
    /export/nfs       *(rw,nohide,insecure,no_subtree_check)  
  '';

  swapDevices = 
    [{
      device = "/swap/swapfile";
      size = 8196;
    }];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  # networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp38s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlo1.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # OpenGL
  hardware.graphics.enable = true;

  # OpenCL
  hardware.graphics.extraPackages = with pkgs; [
    rocmPackages.clr.icd
    rocmPackages.clr
  ];

  # Controllers
  hardware.steam-hardware.enable = true;
  hardware.i2c.enable = true;

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
}
