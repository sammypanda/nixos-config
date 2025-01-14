# Bundle of packages for 3D modelling and texturing and such ^_^
{ config, lib, pkgs, ... }:

{
  # Art packages and software
  environment.systemPackages = with pkgs; [
    blender # 3D modelling
    aseprite # pixel art
    gimp # image manipulation
  ];
}
