{ config, pkgs, inputs, ... }:
let

in {
  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable IPv4 forwarding
  boot.kernel.sysctl = {
    "net.ipv4.conf.all.forwarding" = 1;
  };

  # Enable basic kernel modules
  boot.kernelModules = [ "v4l2loopback" "i2c-dev" ]; 
  boot.extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];

  # Support the icky windows filesystem
  boot.supportedFilesystems = [ "ntfs" ];

  # Enable networking
  networking.networkmanager.enable = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_AU.UTF-8";

  # Block ad/analytics/spam/etc servers
  networking.extraHosts =
    ''
      0.0.0.0 overseauspider.yuanshen.com
      0.0.0.0 uspider.yuanshen.com
      0.0.0.0 dump.gamesafe.gg.com
      0.0.0.0 log-upload-os.hoyoverse.com
      0.0.0.0 sg-public-data-api.hoyoverse.com
    '';

  # Nix settings
  # - enable features that are 'experimental', but basically just being used as if they're not
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" "pipe-operators" ];
  };

  # Configure pipewire
  services.pipewire = {
    # Configuration options that aren't built into NixOS yet
    # - Clock rates
    # - Other stream properties
    extraConfig = {
      pipewire."custom.conf" = {
        context.objects = [
          {
            default.clock.rate = 96000;
            default.clock.allowed-rates = [ 44100 48000 88200 96000 176400 192000 352800 384000 705600 768000 ];

            stream.properties = {
              resample.quality = 10;
            };
          }
        ];
      };
    };

    # Whether to enable the pipewire service
    enable = true;

    # Whether to use pipewire as the primary sound server
    audio.enable = true;
    
    # Route applications using ALSA api through pipewire
    alsa = {
      enable = true;
      support32Bit = true; # support 32-bit ALSA on 64-bit systems
    };
    
    # Backwards compatibility with pulseaudio
    pulse.enable = true;

    # Tools for working with pipewire
    wireplumber.enable = true;
  };

  # Enable virtualisation
  virtualisation.libvirtd.enable = true;

  # Enable XDG desktop portal (program sandboxing)
  xdg.portal = {
    enable = true;
    
    # desktop portal packages
    extraPortals = [ 
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-kde 
    ];

    # desktop portal configurations
    config = {
      common = {
        default = [ "gtk" ]; # GTK as default desktop portal
      };
    };
  };

  # Enable Flatpak; uses XDG
  services.flatpak.enable = true;

  # Enable DConf
  programs.dconf.enable = true;

  # Enable Android Debug Bridge abilities
  programs.adb.enable = true;

  # Install Java
  programs.java = {
    enable = true;
    package = pkgs.openjdk;
  };

  # Enable containers
  # - Configure registries
  # - Set policies
  virtualisation.containers = {
    enable = true;

    registries = {
      search = [ "registry.fedoraproject.org" "registry.access.redhat.com" "registry.centos.org" "docker.io" "quay.io" ];
    };
    policy = {
      default = [{ type = "insecureAcceptAnything"; }];
      transports = {
        docker-daemon = {
          "" = [{ type = "insecureAcceptAnything"; }];
        };
        "dir"= {
          ""= [
            {type="insecureAcceptAnything";}
          ];
        };
        "containers-storage"= {
          ""= [
            {type="insecureAcceptAnything";}
          ];
        };
        "docker" = {
          "docker.io" = [
            {type="insecureAcceptAnything";}
          ];
        };
      };
    };
  };

  # Default applications/software
  environment.systemPackages = with pkgs; [
    wget # retrieving HTTP(S)/FTP
    vim # command line text editor
    git # version tracking software
    tldr # simple explanations/hints for command line
    openal # cross platform 3d audio
    libpulseaudio # sound server (POSIX+Win32)
    alsa-lib # advanced linux sound architecture
    alsa-plugins # it is what it is :3
    ncurses # emulating curses (command line UIs)
    cups # generic paper printing thing
    gnutls # gnu transport layer security
    pinentry # required for gpg_agent
    wineasio # ASIO -> JACK driver (wine)
    ethtool # working with ethernet connections
    usbutils # working with USB devices
    unrar # working with RAR archives
    easyeffects # audio effects
    neofetch # gay n cool system info display
    avahi # mDNS resolution
    openssh # working with SSH protocol
    tmux # really cool command line multi-tasking
    mediainfo # shows details about media files
    yt-dlp # downloading things from youtube
    rsgain # working with ReplayGain
    handbrake # powerful tool/gui for transcoding video
  ];
}