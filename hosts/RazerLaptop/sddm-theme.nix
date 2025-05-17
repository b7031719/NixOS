{ pkgs }:

let
  bkgndLink = "https://github.com/b7031719/NixOS/tree/main/hosts/RazerLaptop/bkgnd.png";
  image = pkgs.fetchurl {
    url = bkgndLink;
    sha256 = "0557bsqa5xc8jbxg4kwfifc8gsn03ji9mkbhj10s2cy7jyvk0zdg";
  };
  basePath = "$out/share/sddm/themes/sddm-astronaut-theme";
in
pkgs.stdenv.mkDerivation {
  name = "sddm-theme";
  src = pkgs.fetchFromGitHub {
    owner = "Keyitdev";
    repo = "sddm-astronaut-theme";
    rev = "bf4d01732084be29cedefe9815731700da865956";
    sha256 = "1sj9b381gh6xpp336lq1by5qsa54chqcgq37r8daqbp2igp8dh14";
  };

  dontWrapQtApps = true;

  propagatedBuildInputs = with pkgs.kdePackages; [
    qtsvg
    qtmultimedia
    qtvirtualkeyboard
  ];

  postPatch = ''
    cp ${image} ./Backrounds
    sed -i 's|^Background="Backgrounds/astronaut.png"$|Background="Backgrounds/bkgnd.png"|' ./Themes/astronaut.conf
  '';

  installPhase = ''
    mkdir -p ${basePath};
    cp -r * ${basePath}
  '';
}
