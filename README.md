# Furhat Stuff

## Prerequisites

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
  };


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

Download the SDK and move it into `./SDK/`

Then start the SDK with:

```console
./launch_furhat_sdk.sh
```

## Gesture Capture Tool

Needs a different JDK and is hence wrapped in a nix-shell

Downloads automatically, invoke with

```console
./launch_gesture_capture.sh
```
