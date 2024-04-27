{ pkgs, ... }:

{
    services = {
        desktopManager.cosmic.enable = true;
        displayManager.cosmic-greeter.enable = true;
    };

    # Available software that isn't enabled by default
    environment.systemPackages = with pkgs; [
        cosmic-design-demo
        cosmic-emoji-picker
        cosmic-protocols
        cosmic-tasks
    ];
}