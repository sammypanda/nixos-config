# Bundle of packages for desktop machines ^_^
{ config, lib, pkgs, ... }:

{
  # Desktop packages and software
  environment.systemPackages = with pkgs; [
    firefox # non-monopolised web browser
    vulkan-loader # graphics + wine
    libva # video acceleration
    libxslt # xsl transforms
    giflib # all about gifs
    libpng # all about pngs
    mpg123 # all about mpegs
    libjpeg # all about jpegs
    v4l-utils # highly compatible video capture?
    mpv # video player (like vlc but current)
    vlc # video player (like mpv but mature)
    soundconverter # transcoding audio files
    wlr-randr # xrandr but for wayland (working with the desktop compositor)
    xwayland # backwards compatibility on wayland to x11
    glxinfo # info about graphics rendering
    gpu-screen-recorder # recording screen but GPU accelerated instead
    mission-center # system monitor/task manager
    libglvnd # potential openglFull dependency (GLES3)
    libGL # bindings for libglvnd
    dxvk # directX (bad) translation layer to vulkan (good)
    vkd3d # direct3D (bad) translation layer to vulkan (good)
    freetype # font rendering engine
    nook-desktop # plays animal crossing music / grandfather clock; time management/productivity
    obs-studio # comprehensive screen recorder
    quodlibet-full # local music player
    logseq # graph-based personal knowledge system
    pomodoro-gtk # productivity timer
  ];
}
