# bitsdojo_window_platform_interface_v3

A common platform interface for the [`bitsdojo_window`][1] plugin.

This interface allows platform-specific implementations of the `bitsdojo_window`
plugin, as well as the plugin itself, to ensure they are supporting the
same interface.

# Usage

To implement a new platform-specific implementation of `bitsdojo_window`, extend
[`BitsdojoWindowPlatform`][2] with an implementation that performs the
platform-specific behavior, and when you register your plugin, set the default
`BitsdojoWindowPlatform` by calling
`BitsdojoWindowPlatform.instance = MyPlatformBitsdojoWindow()`.

# Note on breaking changes

Strongly prefer non-breaking changes (such as adding a method to the interface)
over breaking changes for this package.

See <https://flutter.dev/go/platform-interface-breaking-changes> for a discussion
on why a less-clean interface is preferable to a breaking change.

[1]: ../bitsdojo_window
[2]: lib/bitsdojo_window_platform_interface.dart
