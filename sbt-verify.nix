{ stdenv, scala, sbt, fetchgit }:

stdenv.mkDerivation {
  src = fetchgit {
    url = "https://github.com/input-output-hk/sbt-verify.git";
    rev = "v0.4.1";
    sha256 = "0nwkc4wf02hcxf4bfh62lscbfmavhj6zqmkcp7rc9p381khzg8ac";
  };
  name = "sbtVerify";
  buildInputs = [ scala sbt ];
  buildPhase = ''
    mkdir -p sbt/base
    mkdir -p sbt/boot
    mkdir -p ivy

    sbt -Dsbt.global.base=sbt/base -Dsbt.boot.directory=sbt/boot -Dsbt.ivy.home=ivy publishLocal
  '';

  installPhase = ''
    cp -r ivy $out
    cp -r sbt $out
    cp -r target $out
  '';
}
