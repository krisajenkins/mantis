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
    export HOME=$PWD
    sbt -Dsbt.global.base=.sbt/1.0 -Dsbt.ivy.home=.ivy publishLocal
  '';

  installPhase = ''
    mkdir $out
    cp -r .ivy .sbt target $out
  '';
}
