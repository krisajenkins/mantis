{ stdenv
, fetchgit
, git
, openjdk8
, pandoc
, ocaml
, opam
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
}:

let evmSemanticsSrc = fetchgit {
      url = "https://github.com/kframework/evm-semantics";
      rev = "d9e8102051b99141ca5ad8d33227304225647aa7";
      sha256 = "0z7y1snz49085p2c3kih01yr5j2sxis7wkgxdcmsbakj2lbq1di1";
    };

    # Pre-load the maven dependencies. They don't change much and it takes ages to download.
    mavenDeps = stdenv.mkDerivation {
      name = "kevmMavenDeps";
      src = evmSemanticsSrc;
      buildInputs = [ maven ];
      buildPhase = ''
        mkdir -p $out/.m2
        cd .build/k
        mvn -Dmaven.repo.local=$out/.m2 dependency:resolve
      '';
      installPhase = ''
        echo
      '';
    };
in stdenv.mkDerivation {
  src = evmSemanticsSrc;
  name = "kevm";
  buildInputs = [ git pandoc openjdk8 ocaml opam maven z3 mpfr autoconf automake libtool ncurses unzip curl rsync gcc perl which pkgconfig flex ];
  buildPhase = ''
    export HOME=$PWD

    cp -pr ${mavenDeps}/.m2 $HOME
    chmod -R u+w $HOME/.m2
    substituteInPlace Makefile --replace "mvn" "mvn -Dmaven.repo.local=$HOME/.m2 -Ddependency-check.skip=true"

    substituteInPlace Makefile --replace "git submodule" "echo git submodule"

    substituteInPlace Makefile --replace "k-distribution/target/release/k/lib/opam" "k-distribution/src/main/scripts/lib/opam"

    # mkdir .build/ocaml
    # export OPAMROOT=opam
    # mkdir $OPAMROOT
    # opam init
    # # $(opam config env)

    make deps
    make
  '';

  installPhase = ''
    cp -pr ~/.opam $out/
    cp -pr .build/local/lib/* $out/
    cp -pr .build/vm/* $out/bin/
  '';
}
