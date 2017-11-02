# QLAnsilove

macOS QuickLook plugin for text-mode art supported by the ansilove library. All file formats supported by ansilove are supported by the plugin.

The latest compiled version can be downloaded from [Releases](https://github.com/ansilove/QLAnsilove/releases).

![example rendered folder of files](https://github.com/ansilove/QLAnsilove/blob/master/rendered-folder-example.png)

## Installation

Decompress the .zip file and place `QLAnsilove.qlgenerator` in your `/Library/QuickLook` folder.

You may need to logout of your macOS session or reload the quicklook demon for the plugin to take effect. To reload the quicklook daemon and refresh plugins type `qlmanage -r` from the terminal.

# File Types Supported

- ANSi (.ANS, .CIA, .ICE)
- Binary (.BIN)
- Artworx (.ADF)
- iCE Draw (.IDF)
- Xbin (.XB)
- PCBoard (.PCB)
- Tundra (.TND)
- ASCII (.ASC)
- Release info (.NFO)
- Description in zipfile (.DIZ)
- Membership in zipfile (.MEM)

## Acknowledgements

This plugin is based on the amazing work of [ansilove/C](https://github.com/ansilove/ansilove) and the [ansilove.framework](https://github.com/ansilove/AnsiLove.framework).
