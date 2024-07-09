# System defaults for macOS

Dotfiles are configuration files used in Unix-like operating systems, like Linux and macOS, to store settings for various applications. Although on macOS many preferences aren't kept in dotfiles within the user folder, this repository provides a custom system configuration specifically for macOS.

## Download

This git repository links external repositories as submodules. 
To clone the complete project, use:

```
git clone --recurse-submodules <url>
```

## Usage

There is no need to manually copy files. Three scripts take care of different parts of the configuration.
Please review them carefully before executing. 

> [!IMPORTANT]  
> Run the scripts as user, not with sudo/root.

Apps that are currently configured:
- zsh
- Terminal

## Compatibility

The current configuration has been tested under Mac OS Sonoma 14.0 - 14.5.
Although it will work under previous OS versions, there might be settings that don't have an effect or even break things there.

## References and Credits

- https://github.com/mathiasbynens/dotfiles/
- https://macos-defaults.com/
