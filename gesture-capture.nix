{ pkgs ? import <nixpkgs> {} }: with pkgs;


  pkgs.mkShell {
    # nativeBuildInputs is usually what you want -- tools you need to run
    nativeBuildInputs = [ jdk11 gtk3 ];
    shellHook = ''
     XDG_DATA_DIRS="$GSETTINGS_SCHEMAS_PATH"
     ./GestureCapture/application.linux/FurhatGestureCapture
     exit
    '';
}
