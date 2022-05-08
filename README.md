# [alexmercerind@bitsdojo_window](https://github.com/alexmercerind/bitsdojo_window)

A fork of [bitsdojo_window](https://github.com/bitsdojo/bitsdojo_window) made specifically for [Harmonoid](https://github.com/harmonoid/harmonoid).

DO NOT USE.

## Changes

- Improved `WM_NCHITTEST` & `WM_NCCALCSIZE` handling for better resize behaviours.
- Windows 7, 8, 8.1 & older Windows 10 support.
- Disabled Linux custom frame (to match other Linux applications' behavior).
- Hardcoded `WIN32` class name to `HARMONOID_WIN32_WINDOW` to prevent ambiguity with other Flutter applications.
