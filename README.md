# Furhat Robot on NixOS

This is my collection of configs and tools for using the Furhat SDK on NixOS with the i3 window manager.

## NixOS Prerequisites

In your `configuration.nix`, prepare for the Furhat SDK:

- install JDK8
- install `appimage-run`

```nix
{
  # ...

  environment.systemPackages = with pkgs; [
    # ...

    # furhat SDK is an appimage
    appimage-run

    # ...

  ];


  # furhat SDK needs jdk
  programs.java = {
    enable = true;                # this also sets JAVA_HOME system-wide!!!
    package = pkgs.jdk8;
  };

  # the Furhat GestureCapture tool needs gtk schemas
  # not sure this is needed anymore since we have our nix shell
  programs.dconf.enable = true;

}
```

## Furhat SDK

Download the SDK-desktop-launcher and move it into `./SDK/`

Then start the launcher with:

```console
./launch_furhat_sdk.sh
```

Note: the launcher is wrapped in a `nix-shell` called `sdk.nix`, to provide the GSettings schemas required by the gtk3
filechooser used for choosing skills.

The first time, you will be prompted to install the actual SDK. Enter your SDK key and continue. This will install
everything into `.furhat/`

Since on NixOS installing things to the PATH won't work, add the following to your shell config:

```bash
export PATH=$PATH:~/.furhat/launcher/SDK/2.1.0
```

### JAVA_HOME

Maybe, as indicated by the installer, `~/.furhat/launcher/JDK` should be used as `JAVA_HOME`.

However, I am not sure whether that is absolutely necessary, as the standalone SDK does not require it.

So, for now, I leave `JAVA_HOME` untouched. It defaults to NixOS's system-wide JDK8 one.

## Gesture Capture Tool

Needs a different JDK (JDK11) and is hence wrapped in a nix-shell

Downloads automatically, invoke with

```console
./launch_gesture_capture.sh
```
