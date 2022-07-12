{ pkgs ? import <nixpkgs> {}, ...}:

with pkgs;

let
  inherit (darwin.apple_sdk.frameworks) CoreServices ApplicationServices Security;
  darwin_packages = [ CoreServices ApplicationServices Security];

  nodejs = nodejs-16_x;
  nodePackages = pkgs.nodePackages.override {inherit nodejs;};

  nodePkgs = with nodePackages; [];

  ruby = ruby_3_1;
  rubyPkgs = [
    autoconf bash-completion bison
    docker-compose bzip2 cmake gcc
    gdbm git libffi libiconv libxml2 libxslt libyaml
    ncurses openssl pkgconfig readline
    ruby zlib ];

in mkShell rec {
  name = "www.raunco.co";

  buildInputs = [
    nodejs
  ] ++ nodePkgs ++ rubyPkgs ++ lib.optional stdenv.isDarwin darwin_packages;

  shellHook = ''
    mkdir -p .gems
    export GEM_HOME=$PWD/.gems
    export GEM_PATH=$GEM_HOME
    export PATH=$GEM_HOME/bin:$PATH

    # Add additional folders to to XDG_DATA_DIRS if they exists, which will get sourced by bash-completion
    for p in ''${buildInputs}; do
      if [ -d "$p/share/bash-completion" ]; then
        XDG_DATA_DIRS="$XDG_DATA_DIRS:$p/share"
      fi
    done

    source ${bash-completion}/etc/profile.d/bash_completion.sh
  '';
}
