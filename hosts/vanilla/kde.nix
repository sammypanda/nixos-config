{ pkgs, ... }:

{
    # Enable the KDE Desktop Environment.
    services = {
        displayManager = {
            defaultSession = "plasma";
            sddm = {
                enable = true;
                wayland.enable = true;
            };
        };

        desktopManager = {
            plasma6.enable = true;
        };
    };

    # GTK themes
    programs.dconf.enable = true;

    # Apps for cohesive experience
    environment.systemPackages = with pkgs; [
        kdePackages.libkgapi # for access to google services (like google calendar)
        kdePackages.kdenlive # video editor
        kdePackages.kcalc
        kdePackages.kclock
        kdePackages.korganizer
        kdePackages.knotes
        kdePackages.merkuro
        kdePackages.akonadi
        kdePackages.akonadi-calendar
        kdePackages.akonadi-calendar-tools
        kdePackages.akonadi-contacts
        kdePackages.akonadi-import-wizard
        kdePackages.akonadi-mime
        kdePackages.akonadi-notes
        kdePackages.akonadi-search
        kdePackages.akonadiconsole
        kdePackages.kaccounts-integration
        kdePackages.kaccounts-providers
        kdePackages.signond
        kdePackages.kauth
        kdePackages.libkscreen # screen management
    ];
}
