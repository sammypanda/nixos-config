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
    { device = "/dev/disk/by-uuid/b78899c6-6879-4377-be34-81401402ce1b";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/E2BC-BC93";
      fsType = "vfat";
    };
  
  fileSystems."/home/sammy/Storage" =
    { device = "/dev/disk/by-uuid/5d3e63fe-6569-4e22-8189-cb6d111b7736";
      fsType = "ext4";
    };

  fileSystems."/home/sammy/Speedy" =
    { device = "/dev/disk/by-uuid/b78899c6-6879-4377-be34-81401402ce1b";
      fsType = "ext4";
    };

  fileSystems."/home/sammy/StorageBack" =
    { device = "/dev/disk/by-uuid/4974deb5-b2e6-4c61-8fc7-cb026ffc0a0f";
      fsType = "ext4";
    };

  swapDevices =
    [ 
      { device = "/dev/disk/by-uuid/9ff69f36-ef3d-40e5-9735-96f30f39eca5"; }
    ];

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
  hardware.opengl.enable = true;

  # OpenCL
  hardware.opengl.extraPackages = with pkgs; [
    rocmPackages.clr.icd
    rocmPackages.clr
  ];

  # Vulkan
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;

  # Controllers
  hardware.steam-hardware.enable = true;
  hardware.i2c.enable = true;
}
