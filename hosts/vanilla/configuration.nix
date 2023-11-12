# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

let
  aagl-gtk-on-nix = import (builtins.fetchTarball "https://github.com/ezKEa/aagl-gtk-on-nix/archive/main.tar.gz");
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in
{
  imports =
    [
      ./hardware-configuration.nix
      ./pcloud.nix
      aagl-gtk-on-nix.module
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelModules = [ "v4l2loopback" ];
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

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "amdgpu" ];

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "au";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  security.polkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
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
    tauon = pkgs.tauon.override {
      withDiscordRPC = true; 
    }; 
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.sammy = {
    isNormalUser = true;
    description = "sammy";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      firefox
      nicotine-plus
      discord
      lutris
      yt-dlp
      rhythmbox
      vscode
      stremio
      blender
      godot_4
      obs-studio
      prismlauncher
      aagl-gtk-on-nix.anime-game-launcher
      aagl-gtk-on-nix.anime-borb-launcher
      aagl-gtk-on-nix.honkers-railway-launcher
      aagl-gtk-on-nix.honkers-launcher
      yarn
      kid3
      r128gain
      gparted
      transmission-gtk
      wpsoffice
      libreoffice
      goffice
      jitsi
      calibre
      android-tools
      appimage-run
      caddy
      logseq
      anytype
      thunderbird
      tauon
      sunshine
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment = {
    etc."containers/registries.conf".text = import ../../dotfiles/shared/registries.nix {};
    etc."containers/policy.json".text = import ../../dotfiles/shared/policy.nix {};
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
     vim
     git
     tldr
     gnome3.gnome-tweaks
     gnome-extension-manager # not currently able to install things
     gnome.dconf-editor
     wineWowPackages.stableFull
     wineWowPackages.waylandFull
     wine-wayland
     winetricks
     wineWowPackages.fonts
     samba4Full # for some reason required for some wine processes (ntlm_auth)
     dosbox # wine
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
     unstable.mission-center # viewing all the stats
     gpu-screen-recorder
     libglvnd # potential openglFull dependency (GLES3)
     libGL # bindings for libglvnd
     gnomeExtensions.gsconnect
     avahi # mDNS resolution
     (qt6Packages.callPackage ../../modules/shared/discord-screenaudio { }) # temporary: awaiting official package # community patches for linux screen sharing
     bluez
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
    pinentryFlavor = "gnome3";
  };

  # Steamy
  programs.steam = {
    enable = true;
  };

  # Java
  programs.java = {
    enable = true;
    package = pkgs.openjdk19;
  };

  # Other systemd stuff
  systemd.tmpfiles.rules = [ "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.hip}" ];

  # List services that you want to enable:
  services.flatpak.enable = true;
  services.openldap.enable = true;
  services.avahi = {
    enable = true;
    nssmdns = true; # name-service-switch plug-in
  };

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
    ];
    # Or disable the firewall altogether.
    enable = true;
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
