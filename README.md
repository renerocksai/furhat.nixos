# Furhat Robot on NixOS

This is my nix flake for using the Furhat SDK on NixOS with the i3 window manager.

#### Note (NVIDIA):

I enabled my NVIDIA on NixOS 22.05 and the electron app doesn't start anymore.

See [README.old.md](./README.old.md) if problems persist. However, the nixGL
variants might work now.

## Install the Furhat SDK

Download the SDK-desktop-launcher app image from
[furhat.io](https://furhat.io/downloads) and move it into `./SDK/`



## Start Furhat SDK (virtual robot) 

```console
$ nix run github:renerocksai/furhat.nixos
```

If on a ChromeBook or when having graphics card problems, try the `nixGL`
version:

```console
$ nix run --impure github:renerocksai/furhat.nixos#furhat-nixgl
```

The first time, you will be prompted to install the actual SDK. Enter your SDK
key and continue. This will install everything into `~/.furhat/`


**JAVA_HOME:**

Maybe, as indicated by the installer, `~/.furhat/launcher/JDK` should be used as `JAVA_HOME`.

However, I am not sure whether that is absolutely necessary, as the standalone SDK does not require it.

So, for now, I leave `JAVA_HOME` untouched. It defaults to NixOS's system-wide JDK8 one.

## Gesture Capture Tool

Needs a different JDK (JDK11) and GTK3 input dialogs seem to only work with
schamas, etc.

Downloads automatically, invoke with

```console
$ nix run github:renerocksai/furhat.nixos#gesture-capture
```

**NOTE**: If download fails, update the URL and zip file name from [the
docs](https://docs.furhat.io/gesture_capture_tool/).
