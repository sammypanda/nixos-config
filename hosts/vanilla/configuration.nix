# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, pkgs-unstable, pkgs-24_05, inputs, ... }:

let
  system = builtins.currentSystem;
  edid-samsung-q800t = pkgs.runCommandNoCC "edid-samsung-q800t" { compressFirmware = false; } ''
    mkdir -p $out/lib/firmware/edid
    echo "AP///////wBMLUBwAA4AAQEeAQOApV14Cqgzq1BFpScNSEi974BxT4HAgQCBgJUAqcCzANHACOgAMPJwWoCwWIoAUB10AAAeb8IAoKCgVVAwIDUAUB10AAAaAAAA/QAYeA//dwAKICAgICAgAAAA/ABTQU1TVU5HCiAgICAgAW4CA2fwXWEQHwQTBRQgISJdXl9gZWZiZD9AdXba28LDxMbHLAkHBxUHUFcHAGdUAIMBAADiAE/jBcMBbgMMAEAAmDwoAIABAgMEbdhdxAF4gFkCAADBNAvjBg0B5Q8B4PAf5QGLhJABb8IAoKCgVVAwIDUAUB10AAAaAAAAAAAAZw==" | base64 -d > "$out/lib/firmware/edid/samsung-q800t-hdmi2.1"
  '';
in
{
  imports =
    [
      # Config modules
      ./hardware-configuration.nix
      
      # Desktops
      #./cosmic.nix
      ./kde.nix

      # Patches/apps
      ./pcloud.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelModules = [ "v4l2loopback" "i2c-dev" ]; 
  
  boot.kernelParams = [ "drm.edid_firmware=HDMI-A-3:edid/samsung-q800t-hdmi2.1" "video=HDMI-A-3:e" ]; 
  hardware.firmware = [ edid-samsung-q800t ]; 

  boot.extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
  boot.supportedFilesystems = [ "ntfs" ];
  boot.kernel.sysctl = {
    "net.ipv4.conf.all.forwarding" = 1;
    "net.ipv4.conf.enp38s0.route_localnet" = 1;
  };

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.extraHosts =
    ''
      0.0.0.0 overseauspider.yuanshen.com
      0.0.0.0 uspider.yuanshen.com
      0.0.0.0 dump.gamesafe.gg.com
      0.0.0.0 log-upload-os.hoyoverse.com
      0.0.0.0 sg-public-data-api.hoyoverse.com
    '';

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Australia/Brisbane";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_AU.UTF-8";
    LC_IDENTIFICATION = "en_AU.UTF-8";
    LC_MEASUREMENT = "en_AU.UTF-8";
    LC_MONETARY = "en_AU.UTF-8";
    LC_NAME = "en_AU.UTF-8";
    LC_NUMERIC = "en_AU.UTF-8";
    LC_PAPER = "en_AU.UTF-8";
    LC_TELEPHONE = "en_AU.UTF-8";
    LC_TIME = "en_AU.UTF-8";
  };

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

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  security.polkit.enable = true;
  services.pipewire = {
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

    enable = true;
    audio.enable = true;
    
    alsa = {
      enable = true;
      support32Bit = true;
    };
    
    pulse = {
      enable = true;
    };

    wireplumber = {
      enable = true;
    };

    # If you want to use JACK applications, uncomment this
    jack = {
      enable = true;
    };
  };

  # Container configuration
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

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Overlays (for nixpkgs)
  # godot(latest) -> godot(4.0.1)
  # nixpkgs.overlays = [
  #       	(final: prev: {
  #       		godot_4 = prev.godot_4.overrideAttrs (old: {
  #       			src = prev.fetchFromGitHub {
  #       				owner = "godotengine";
  #       				repo = "godot";
  #       				rev = "4.0.1-stable";
  #       				hash = "sha256-0PDKZ92PJo9N5oP56/Z8bzhVhfO7IHdtQ5rMj5Difto=";
  #       			};
  #       		});
  #       	})
  #       ];

  # Nixpkg Overrides
  nixpkgs.config.packageOverrides = pkgs: {
    retroarch = pkgs.retroarch.override {
      cores = with pkgs.libretro; [
        dolphin
      ];
    };

    feishin = pkgs.feishin.override {
      version = "0.6.0";

      electron_24 = pkgs.electron_27;
    };
  };

  # Home manager, the better way to define user account.
  home-manager.users = {
    sammy = {

      home.stateVersion = "23.05";

      # VSCodium
      programs.vscode = {
        enable = true;
        package = pkgs.vscodium;
        extensions = with pkgs; [
          vscode-extensions.enkia.tokyo-night
          vscode-extensions.redhat.java
          vscode-extensions.jnoortheen.nix-ide
          extensions.vscode-marketplace.leonardssh.vscord
          vscode-extensions.devsense.phptools-vscode
          extensions.vscode-marketplace.trag1c.gleam-theme
          vscode-extensions.betterthantomorrow.calva
          vscode-extensions.arrterian.nix-env-selector
        ];
      };
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.sammy = {
    isNormalUser = true;
    description = "sammy";
    extraGroups = [ "networkmanager" "wheel" "adbusers" ];
    packages = with pkgs; [
      firefox
      nicotine-plus
      yt-dlp
      rhythmbox
      stremio
      blender
      godot_4
      obs-studio
      prismlauncher
      yarn
      kid3
      rsgain
      gparted
      (transmission_3.override { enableQt = true; })
      wpsoffice
      libreoffice
      goffice
      jitsi
      calibre
      android-tools
      appimage-run
      caddy
      # logseq # TODO: dilapidated software, wait for update
      anytype
      thunderbird
      quodlibet-full
      deadbeef-with-plugins
      nuclear
      proton-caller
      syncthing
      retroarch
      #suyu # switch emulator
      ryujinx # performant switch emulator
      dolphin-emu # gamecube/wii/triforce emulator
      xdotool # for window swapping reasons (sunshine game streaming)
      arrpc # for discord rich presence
      aseprite # pixel art!
      steam-run # to launch steam games (sunshine game streaming)
      super-productivity # tracking tasks/hours
      teams-for-linux # Microsoft Teams
      sonixd # desktop subsonic player
      feishin # desktop navidrome player
      openrgb-with-all-plugins # controlling the colours!!
      virt-manager # virtual machines
      kotatogram-desktop # telegram client
      gimp # image manipulation program
      pipecontrol
      mediainfo
      handbrake # powerful tool/gui for working with video formats
      jellyfin-media-player # local network media player
      nook-desktop # plays animal crossing music / grandfather clock; time management/productivity
      arnis # cool tool that generates minecraft worlds from real geospatial data
      pcsx2 # ps2 emu
      cartridges # show all ur gamies
      xivlauncher
      pomodoro-gtk # working timer
      dbgate # database manager (backup)
      beekeeper-studio # database manager (backup)
      antares # database manager
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Sunshine capture
  security.wrappers.sunshine = {
    owner = "root";
    group = "root";
    capabilities = "cap_sys_admin+p";
    source = "${pkgs.sunshine}/bin/sunshine";
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    git
    tldr
    nix-gaming.wine-ge # better wine >:3
    wineWowPackages.waylandFull
    winetricks
    wineWowPackages.fonts
    lutris
    vulkan-loader # graphics + wine
    libva # video acceleration
    libxslt # xsl transforms
    giflib # all about gifs
    libpng # all about pngs
    mpg123 # all about mpegs
    libjpeg # all about jpegs
    openal # cross platform 3d audio
    v4l-utils # highly compatible video capture?
    libpulseaudio # sound server (POSIX+Win32)
    alsa-lib # advanced linux sound architecture
    alsa-plugins # it is what it is :3
    ncurses # emulating curses
    ocl-icd # opencl icd loader (used in wine)
    jansson # C library for JSON stuff (used in wine)
    cups # lol (generic printing thing)
    gnutls # gnu transport layer security
    pinentry # required for gpg_agent
    wineasio # ASIO -> JACK driver (wine)
    rustup
    wget
    losslesscut-bin
    ethtool
    usbutils
    vlc
    unrar
    soundconverter
    neofetch
    wlr-randr
    easyeffects
    radeontop
    xwayland
    podman
    distrobox
    glxinfo
    mission-center # viewing all the stats
    gpu-screen-recorder
    libglvnd # potential openglFull dependency (GLES3)
    libGL # bindings for libglvnd
    avahi # mDNS resolution
    (qt6Packages.callPackage ../../modules/shared/discord-screenaudio { }) # temporary: awaiting official package # community patches for linux screen sharing
    vesktop # discord + vencord
    bluez
    bluez-alsa
    tmux
    mpv
    dxvk
    vkd3d
    freetype
    openssh
    sunshine
    kdePackages.qtstyleplugin-kvantum
    steamtinkerlaunch # more detailed steam game config
    deno # version 2.0.0
  ];

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      corefonts # Arial, Verdana, ...
      vistafonts # Consolas, ...
      google-fonts # Droid Sans, Roboto, ...
      ubuntu_font_family
      openmoji-color
    ];
    fontconfig = {
      includeUserConf = false;
      defaultFonts = {
        serif = [ "Gentium Plus" ];
        sansSerif = [ "Cantarell" ];
        monospace = [ "Source Code Pro" ];
        emoji = [ "OpenMoji Color" ];
      };
    };
    fontDir.enable = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Steamy
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };

  # Java
  programs.java = {
    enable = true;
    package = pkgs.openjdk;
  };

  # ADB + etc
  programs.adb = {
    enable = true;
  };

  # DConf
  programs.dconf = {
    enable = true;
  };

  # Other systemd stuff
  systemd.tmpfiles.rules = [ "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}" ];

  # List services that you want to enable:
  services.flatpak.enable = true;
  services.openldap.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true; # name-service-switch plug-in
    publish.enable = true;
    publish.userServices = true; # multi-user
  };
  services.udev = {
    packages = [
      pkgs.android-udev-rules
      pkgs.openrgb
      pkgs.sunshine
    ];
  };
  services.ollama = {
    enable = true;
    acceleration = "rocm";
    environmentVariables = {
      ROC_ENABLE_PRE_VEGA = "1";
      OLLAMA_HOST = "0.0.0.0:11434";
      HCC_AMDGPU_TARGET = "gfx1032";
      HSA_OVERRIDE_GFX_VERSION="10.3.0";
    };
    host = "0.0.0.0";
    port = 11434;
  };

  # Enable virtualisation
  virtualisation.libvirtd.enable = true;
  virtualisation.waydroid.enable = true;

  # Nix settings
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
  };

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall = {
    allowedTCPPorts = [ 25565 8000 47989 47984 48010 ];
    allowedUDPPorts = [ 25565 8000 48010 47998 47999 47800 48000 48010 ];
    allowedTCPPortRanges = [
      { from = 2234; to = 2239; }
      { from = 1716; to = 1764; }
    ];
    allowedUDPPortRanges = [
      { from = 2234; to = 2239; }
      { from = 1716; to = 1764; }
      { from = 47998; to = 48000; }
      { from = 8000; to = 8010; }
    ];
    # Or disable the firewall altogether.
    enable = false;
  };

  networking.interfaces.enp38s0 = {
    ipv4.addresses = [
      {
        address = "192.168.1.116";
        prefixLength = 24;
      }
    ];

    useDHCP = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
