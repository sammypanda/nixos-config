# Bundle of packages for office stuff
{ config, lib, pkgs, ... }:

{
  # Office packages and software
  environment.systemPackages = with pkgs; [
    libreoffice
  ];
}
