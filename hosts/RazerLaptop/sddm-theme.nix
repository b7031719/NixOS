{ pkgs }:

let
  bkgndLink = "https://raw.githubusercontent.com/b7031719/NixOS/main/hosts/RazerLaptop/bkgnd.mp4";
  bkgnd = pkgs.fetchurl {
    url = bkgndLink;
    sha256 = "0snhwz9am48q2nxsahj9fm0d87ar77554l97s05ab7ig4b1lfdnx";
  };
  basePath = "$out/share/sddm/themes/sddm-astronaut-theme";
in
pkgs.stdenvNoCC.mkDerivation {
  name = "sddm-theme";
  src = pkgs.fetchFromGitHub {
    owner = "Keyitdev";
    repo = "sddm-astronaut-theme";
    rev = "bf4d01732084be29cedefe9815731700da865956";
    sha256 = "1sj9b381gh6xpp336lq1by5qsa54chqcgq37r8daqbp2igp8dh14";
  };

  dontWrapQtApps = true;

  installPhase = ''
    mkdir -p ${basePath}
    cp -r * ${basePath}/
    cp ${bkgnd} ${basePath}/Backgrounds/bkgnd.mp4
    sed -i 's|^Background="Backgrounds/astronaut.png"$|Background="Backgrounds/bkgnd.mp4"|' ${basePath}/Themes/astronaut.conf
    install -dm755 "$out/share/fonts"
  '';

}
