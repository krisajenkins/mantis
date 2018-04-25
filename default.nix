{ stdenv, scala, sbt, fetchgit, callPackage, unzip }:

let sbtVerify = callPackage ./sbt-verify.nix { };
in
stdenv.mkDerivation {
  src = fetchgit {
    url = "https://github.com/input-output-hk/mantis.git";
    rev = "8f4961abb0ea85d64a3fae71341140505f35f932";
    sha256 = "06yd88hy5cbv4b9mp6livz8fi3l1k0kr8jkix64snpj772vjz59s";
  };

  name = "mantis";
  buildInputs = [ scala sbt sbtVerify unzip ];
  buildPhase = ''
    mkdir ivy
    cp -r ${sbtVerify}/cache ivy
    cp -r ${sbtVerify}/local ivy
    cp -r ${sbtVerify}/sbt .
    cp -r ${sbtVerify}/target .
    chmod -R u+w ivy sbt target

    sbt -Dsbt.global.base=sbt/base -Dsbt.boot.directory=sbt/boot -Dsbt.ivy.home=ivy 'set test in Test := {}' dist
  '';

  installPhase = ''
    mkdir $out
    unzip target/universal/mantis-1.0-daedalus-rc1.zip
    mv mantis-1.0-daedalus-rc1/* $out
  '';
}
