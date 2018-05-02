{ stdenv
, fetchgit
, git
, openjdk8
, pandoc
, opam
, ocaml
, maven
, z3
, mpfr
, autoconf
, automake
, libtool
, ncurses
, unzip
, curl
, rsync
, gcc
, perl
, which
, pkgconfig
, flex
, python3
, zlib
}:

let evmSemanticsSrc = fetchgit {
      url = "https://github.com/kframework/evm-semantics";
      rev = "d9e8102051b99141ca5ad8d33227304225647aa7";
      sha256 = "0z7y1snz49085p2c3kih01yr5j2sxis7wkgxdcmsbakj2lbq1di1";
    };
in stdenv.mkDerivation {
  name = "kevm";
  src = evmSemanticsSrc;
  patches = [ ./kevm.patch ];
  buildInputs = [ pandoc openjdk8 ocaml opam maven z3 mpfr autoconf automake libtool ncurses unzip curl rsync gcc perl which pkgconfig flex zlib python3 ];
  buildPhase = ''
    export HOME=$PWD

    make deps
    make
  '';
  installPhase = ''
    mkdir -p $out/bin
    cp -pr .build/local/lib $out/
    cp -pr .build/vm/* $out/bin/
  '';
}
