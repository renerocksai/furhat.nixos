{
  description = "slides dev shell";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-22.11";
    flake-utils.url = "github:numtide/flake-utils";

    # required for latest zig
    zig.url = "github:mitchellh/zig-overlay";

    # for chromeos etc
    nixgl.url = "github:guibou/nixGL";

    # Used for shell.nix
    flake-compat = {
      url = github:edolstra/flake-compat;
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    nixgl,
    ...
  } @ inputs: let
    overlays = [ nixgl.overlay ];

    # Our supported systems are the same supported systems as the Zig binaries
    systems = builtins.attrNames inputs.zig.packages;
  in
    flake-utils.lib.eachSystem systems (
      system: let
        pkgs = import nixpkgs {inherit overlays system; };
      in rec {

        #
        # DEFAULT devShell
        #
        devShells.default = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            neovim
            appimage-run
            jdk8
          ];

          buildInputs = with pkgs; [
            # we need a version of bash capable of being interactive
            # as opposed to a bash just used for building this flake 
            # in non-interactive mode
            bashInteractive 
          ];

          shellHook = ''
            # once we set SHELL to point to the interactive bash, neovim will 
            # launch the correct $SHELL in its :terminal 
            export SHELL=${pkgs.bashInteractive}/bin/bash
          '';
        };

        #
        # NIXGL devShell
        #
        # this shell needs to be run with
        # nix develop --impure .#nixgl 
        devShells.nixgl = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            neovim
            appimage-run
            jdk8
            pkgs.nixgl.auto.nixGLDefault
          ];

          buildInputs = with pkgs; [
            # we need a version of bash capable of being interactive
            # as opposed to a bash just used for building this flake 
            # in non-interactive mode
            bashInteractive 
          ];

          shellHook = ''
            # once we set SHELL to point to the interactive bash, neovim will 
            # launch the correct $SHELL in its :terminal 
            export SHELL=${pkgs.bashInteractive}/bin/bash
          '';
        };


        ###
        ### run the sdk directly
        ###
        packages.furhat = pkgs.writeShellApplication {
          name = "Furhat SDK desktop launcher";
          runtimeInputs = with pkgs; [
            appimage-run
            jdk8
            # gtk3 not needed (on my system)
          ];

          text = ''

            if [ -f ./SDK/furhat-sdk-desktop-launcher.AppImage ] ; then
                appimage-run SDK/*.AppImage
            else
                appimage-run ~/code/github.com/renerocksai/furnat.nixos/SDK/*.AppImage
            fi
          '';
        };

        ### NIXGL run the sdk directly
        packages.furhat-nixgl = pkgs.writeShellApplication {
          name = "Furhat SDK desktop launcher";
          runtimeInputs = with pkgs; [
            appimage-run
            jdk8
            pkgs.nixgl.auto.nixGLDefault
          ];

          text = ''
            if [ -f ./SDK/furhat-sdk-desktop-launcher.AppImage ] ; then
                nixGL appimage-run SDK/*.AppImage
            else
                nixGL appimage-run ~/code/github.com/renerocksai/furnat.nixos/SDK/*.AppImage
            fi
          '';
        };

        ###
        ### run the GESTURE CAPTURE tool
        ###
        packages.gesture-capture = pkgs.writeShellApplication {
          name = "Furhat Gesture Capture";
          runtimeInputs = with pkgs; [
            gtk3
            gsettings-desktop-schemas
            jdk11
            wget
            unzip
          ];

          text = ''
            if [ ! -d GestureCapture ] ; then
                wget https://furhat-files.s3.eu-west-1.amazonaws.com/gesturecapture/FurhatGestureCapture_linux64_v0.0.7.zip
                unzip -d GestureCapture FurhatGestureCapture_linux64_v0.0.7.zip
                rm FurhatGestureCapture_linux64_v0.0.7.zip
            fi
            export XDG_DATA_DIRS="${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}:${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}:${pkgs.hicolor-icon-theme}/share"
            ./GestureCapture/application.linux/FurhatGestureCapture
          '';
        };


        # For compatibility with older versions of the `nix` binary
        devShell = self.devShells.${system}.default;
        defaultPackage = packages.furhat;
      }
    );
}
