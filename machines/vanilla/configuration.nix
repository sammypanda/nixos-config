# Configuration for the 'vanilla' machine.
#
# CPU: Ryzen 5 3400G
# GPU: Radeon 6600XT
# Monitors: BenQ PD2705Q, LG 49WL95C-WE
# Keyboard: Lenovo KU-0225
# Mouse: Cougar Revenger
# Speakers: Creativ I-Trigue 3400 (Stereo 2.1)
#
{ pkgs, inputs, config, ... }:
let
  edid-samsung-q800t = pkgs.runCommandNoCC "edid-samsung-q800t" { compressFirmware = false; } ''
    mkdir -p $out/lib/firmware/edid
    echo "AP///////wBMLUBwAA4AAQEeAQOApV14Cqgzq1BFpScNSEi974BxT4HAgQCBgJUAqcCzANHACOgAMPJwWoCwWIoAUB10AAAeb8IAoKCgVVAwIDUAUB10AAAaAAAA/QAYeA//dwAKICAgICAgAAAA/ABTQU1TVU5HCiAgICAgAW4CA2fwXWEQHwQTBRQgISJdXl9gZWZiZD9AdXba28LDxMbHLAkHBxUHUFcHAGdUAIMBAADiAE/jBcMBbgMMAEAAmDwoAIABAgMEbdhdxAF4gFkCAADBNAvjBg0B5Q8B4PAf5QGLhJABb8IAoKCgVVAwIDUAUB10AAAaAAAAAAAAZw==" | base64 -d > "$out/lib/firmware/edid/samsung-q800t-hdmi2.1"
  '';
  ecosystems = [
    "art"
    "desktop"
    "gaming"
    "office"
  ];
in {

  imports = map (ecosystem: ../../modules/ecosystems/${ecosystem}.nix) ecosystems;

  boot.initrd.kernelModules = [ "amdgpu" ];
  
  # Add virtual display
  # - good for streaming connection to the desktop
  boot.kernelParams = [ "drm.edid_firmware=HDMI-A-3:edid/samsung-q800t-hdmi2.1" "video=HDMI-A-3:e" ]; 
  hardware.firmware = [ edid-samsung-q800t ]; 

  boot.kernel.sysctl = {
    "net.ipv4.conf.enp38s0.route_localnet" = 1;
  };

  # Set your time zone.
  time.timeZone = "Australia/Brisbane";

  # Configure display/window/desktop
  services = {
    xserver = {
      enable = true;
      videoDrivers = [ "amdgpu" ];

      # Configure keymap in X11
      xkb = {
        layout = "au";
        variant = ""; 
      };
    };
  };

  # Enable CUPS to print documents
  services.printing.enable = true;

  # Daemon that allows any process to use real-time scheduling
  # (audio is an example of a real-time process, it should be prioritised urgently)
  security.rtkit.enable = true;

  # Workaround sotware hard-coding HIP libraries (AMD GPU)
  systemd.tmpfiles.rules = [ "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}" ];

  # Configuration for each network interface
  networking.interfaces = {
    # The main physical ethernet port
    enp38s0 = {
      # Declare IPv4 addresses
      ipv4.addresses = [
        # Set a specified static address
        {
          address = "192.168.1.116";
          prefixLength = 24;
        }
      ];

      # Configure this interface with DHCP
      useDHCP = true;
    };
  };

  # Determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken.
  system.stateVersion = "23.05";
}