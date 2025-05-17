{ pkgs }:

let
  bkgndLink = "https://raw.githubusercontent.com/b7031719/NixOS/main/hosts/RazerLaptop/bkgnd.png";
  image = pkgs.fetchurl {
    url = bkgndLink;
    sha256 = "0557bsqa5xc8jbxg4kwfifc8gsn03ji9mkbhj10s2cy7jyvk0zdg";
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

  propagatedBuildInputs = with pkgs.kdePackages; [
    qtbase
    qtdeclarative
    qtquicktimeline
    qtsvg
    qtmultimedia
    qtvirtualkeyboard
  ];

  installPhase = ''
    mkdir -p ${basePath}
    cp -r * ${basePath}/
    cp ${image} ${basePath}/Backgrounds/bkgnd.png
    sed -i 's|^Background="Backgrounds/astronaut.png"$|Background="Backgrounds/bkgnd.png"|' ${basePath}/Themes/astronaut.conf
    install -dm755 "$out/share/fonts"
    cp -r "$out/share/sddm/themes/sddm-astronaut-theme/Fonts/." "$out/share/fonts"
    sed -i 's/^import QtMultimedia$/import QtMultimedia 6.8/' ${basePath}/Main.qml
  '';

    # sed -i 's/^import QtQuick\.Effects$/import QtQuick.Effects 1.0/' ${basePath}/Main.qml
  postFixup = ''
    mkdir -p $out/nix-support
    echo ${pkgs.kdePackages.qtsvg} >> $out/nix-support/propagated-user-env-packages
    echo ${pkgs.kdePackages.qtmultimedia} >> $out/nix-support/propagated-user-env-packages
    echo ${pkgs.kdePackages.qtvirtualkeyboard} >> $out/nix-support/propagated-user-env-packages
  '';
}
