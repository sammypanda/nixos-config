# Bundle of gaming packages for gaming machines :)
{ config, lib, pkgs, ... }:

{
  # Gaming packages and utilities
  environment.systemPackages = with pkgs; [
    nix-gaming.wine-ge # better wine >:3
    wineWowPackages.waylandFull # wayland wine
    wineWowPackages.fonts # fonts for wine
    winetricks # for adding things to wine
    lutris # linux videogame instance manager
    winePackages.staging # cutting edge wine packages
    ocl-icd # opencl icd loader (used in wine)
    jansson # C library for JSON stuff (used in wine)
    steamtinkerlaunch # external configuring/launching steam games
    arrpc # for discord rich presence
    prismlauncher # minecraft instance manager
    arnis # cool tool that generates minecraft worlds from real geospatial data
    cartridges # cute way to launch games from all sources
    xivlauncher # final fantasy XIV launcher
  ];

  # Install Steamy
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };
}
