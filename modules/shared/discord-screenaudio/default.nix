{ lib
, stdenv
, fetchFromGitHub
, wrapQtAppsHook
, cmake
, qtbase
, qtwebengine
, knotifications
, kxmlgui
, kglobalaccel
, pipewire
, nix-update-script
}:

stdenv.mkDerivation rec {
  pname = "discord-screenaudio";
  version = "1.8.2";

  src = fetchFromGitHub {
    owner = "maltejur";
    repo = "discord-screenaudio";
    rev = "v${version}";
    hash = "sha256-aJ0GTekqaO8UvbG3gzYz5stA9r8pqjTHdR1ZkBHPMeo=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    wrapQtAppsHook
    cmake
    qtbase
    qtwebengine
    knotifications
    kxmlgui
    kglobalaccel
  ];

  buildInputs = [
    pipewire
  ];

  cmakeFlags = [
    "-DPipeWire_INCLUDE_DIRS=${pipewire.dev}/include/pipewire-0.3"
    "-DSpa_INCLUDE_DIRS=${pipewire.dev}/include/spa-0.2"
  ];

  preConfigure = ''
    # version.cmake either uses git tags or a version.txt file to get app version.
    # Since cmake can't access git tags, write the version to a version.txt ourselves.
    echo "${version}" > version.txt
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "A custom discord client that supports streaming with audio on Linux";
    homepage = "https://github.com/maltejur/discord-screenaudio";
    downloadPage = "https://github.com/maltejur/discord-screenaudio/releases";
    changelog = "https://github.com/maltejur/discord-screenaudio/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ huantian ];
    platforms = platforms.linux;
  };
}