{ pkgs ? import <nixpkgs> {} }: with pkgs;


  pkgs.mkShell {
    nativeBuildInputs = [ gtk3 ];
    shellHook = ''
     XDG_DATA_DIRS="$GSETTINGS_SCHEMAS_PATH"
     appimage-run SDK/*.AppImage
     exit
    '';
}
