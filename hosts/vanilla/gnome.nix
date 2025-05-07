{ pkgs, ... }:

{
    # Enable the KDE Desktop Environment.
    services = {
        xserver = {
            enable = true;

            displayManager = {
                gdm = {
                    enable = true;
                };
            };

            desktopManager = {
                gnome.enable = true;
            };
        };
    };

    # GTK themes
    programs.dconf.enable = true;

    # Apps for cohesive experience
    environment.systemPackages = with pkgs; [
        adwaita-icon-theme
        gnomeExtensions.appindicator
        sysprof
        gnome-tweaks
    ];

    services.udev.packages = with pkgs; [ 
        gnome-settings-daemon
    ];

    services.dbus.packages = with pkgs; [ 
        gnome2.GConf 
    ];
    
    nixpkgs.overlays = [
        (final: prev: {
            mutter = prev.mutter.overrideAttrs (old: {
                src = pkgs.fetchFromGitLab {
                    domain = "gitlab.gnome.org";
                    owner = "vanvugt";
                    repo = "mutter";
                    rev = "triple-buffering-v4-47";
                    hash = "sha256-C2VfW3ThPEZ37YkX7ejlyumLnWa9oij333d5c4yfZxc=";
                };
            });
        })
    ];

    # Required for triple buffering? ^
    nixpkgs.config.allowAliases = false;

    # System profiling
    services.sysprof.enable = true;

    # Screen rotation
    hardware.sensor.iio.enable = true;
}
