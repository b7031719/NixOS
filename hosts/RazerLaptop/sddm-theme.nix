{ pkgs }:

let
  bkgndLink = "https://github.com/b7031719/NixOS/tree/main/hosts/RazerLaptop/bkgnd.jpg";
  image = pkgs.fetchurl {
    url = bkgndLink;
    sha256 = "03b6hz1y4xj79961lgmr2035jm41j6jv66c9j100jwgrygxa3l2g";
  };
pkgs.stdenv.mkDerivation {
  name = "sddm-theme";
  src = pkgs.fetchFromGitHub {
    owner = "Keyitdev";
    repo = "sddm-astronaut-theme";
    rev = "bf4d01732084be29cedefe9815731700da865956";
    sha256 = "1sj9b381h6xpp336lq1by5qsa54chqcq37r8daqbp2igp8dh14";
  };
  propagatedBuildInputs = with pkgs.kdePackages; {
    qtsvg
    qtmultimedia
    qtvirtualkeyboard
  };
  installPhase = ''
    mkdir -p $out
    mkdir -p $out/Backgrounds
    cp $image $out/Backgrounds
    cp -r ./* $out/
  '';
}
