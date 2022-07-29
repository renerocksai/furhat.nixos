# Furhat Robot on NixOS

This is my collection of configs and tools for using the Furhat SDK on NixOS with the i3 window manager.

## Update

I enabled my NVIDIA on NixOS 22.05 and the electron app doesn't start anymore.

```console
➜ ./launch_furhat_sdk.sh
furhat-sdk-desktop-launcher.AppImage installed in /home/rs/.cache/appimage-run/7c524ce81c6c063fa57a95fa38c7e25b28923d3d2e33018c13a9ea03faca65d9
(node:38851) electron: The default of contextIsolation is deprecated and will be changing from false to true in a future release of Electron.  See https://github.com/electron/electron/issues/23506 for more information
[38851:0729/133606.358419:FATAL:gpu_data_manager_impl_private.cc(445)] GPU process isn't usable. Goodbye.
```

However, I can still run the **already installed** SDK, ignoring the launcher:

```console
cd ~/.furhat/launcher/SDK/2.3.0
steam-run bin/furhatos &
```

I can then open the web interface to control everything:

```console
xdg-open http://localhost:8080
```

Hence, see [newsdk.sh](./newsdk.sh) for how I work with the SDK now.

I start a skill like this, usually from my `Makefile`:

```
java -cp ./build/libs/my-awesome-sill-all.skill furhatos.skills.Skill
```

### Upgrading the SDK

Well, I'll urge Furhat to make the standalone SDK available again for download, like it is described in their docs.

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
