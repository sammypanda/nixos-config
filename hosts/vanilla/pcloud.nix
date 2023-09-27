{ pkgs, lib, ... }:

let
  pkgs_22_11 = import (pkgs.fetchFromGitHub {
    owner = "nixos";
    repo = "nixpkgs";
    rev = "f7c1500e2eefa58f3c80dd046cba256e10440201";
    hash = "sha256-sDd7QIcMbIb37nuqMrJElvuyE5eVgWuKGtIPP8IWwCc=";
  }) {
    config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "pcloud"
    ];
  };

  pcloud_22_11 = pkgs_22_11.pcloud.overrideAttrs (prev:
    let
      version = "1.13.0";
      code = "XZecm6VZIz4VKYBrUbzzhcfNW9boSfrfhgaV";
      # Archive link's codes: https://www.pcloud.com/release-notes/linux.html
      src = pkgs.fetchzip {
        url = "https://api.pcloud.com/getpubzip?code=${code}&filename=${prev.pname}-${version}.zip";
        hash = "sha256-eJpwoVCI96Yow7WfVs3rRwC4D1kh7x7HuMFU7YEFHCM=";
      };

      appimageContents = pkgs.appimageTools.extractType2 {
        name = "${prev.pname}-${version}";
        src = "${src}/pcloud";
      };
    in
    {
      inherit version;
      src = appimageContents;
    });
in

{
  config.environment.systemPackages = [
    pcloud_22_11
  ];
}
