{
  description = "www.raunco.co";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat.url = "github:edolstra/flake-compat";
    flake-compat.flake = false;
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ...
  } @ inputs: let
    foo  = "hey";
  in
    flake-utils.lib.eachDefaultSystem
    (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
        inherit (pkgs.darwin.apple_sdk.frameworks) CoreServices ApplicationServices Security;
        darwin_packages = [ CoreServices ApplicationServices Security];

        nodejs = pkgs.nodejs-18_x;
        nodePackages = pkgs.nodePackages.override {inherit nodejs;};
        nodePkgs = with nodePackages; [typescript typescript-language-server yarn];

      in rec {

        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            autoconf
            bash-completion
            bison
            bzip2
            cmake
            docker-compose
            gcc
            gdbm
            git
            libffi
            libiconv
            libxml2
            libxslt
            libyaml
            ncurses
            nodejs
            openssl
            pkg-config
            readline
            ruby_3_2
            zlib
          ]  ++ nodePkgs ++ lib.optional stdenv.isDarwin darwin_packages;
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

            source ${pkgs.bash-completion}/etc/profile.d/bash_completion.sh
          '';
        };
      }
    );
}
