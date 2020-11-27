#ifndef FLUTTER_PLUGIN_BITSDOJO_WINDOW_PLUGIN_H_
#define FLUTTER_PLUGIN_BITSDOJO_WINDOW_PLUGIN_H_

#include <flutter_plugin_registrar.h>

#define FLUTTER_PLUGIN_EXPORT __declspec(dllexport)

#if defined(__cplusplus)
extern "C" {
#endif

FLUTTER_PLUGIN_EXPORT void BitsdojoWindowPluginRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar);

#define BDW_CUSTOM_FRAME    0x1
#define BDW_HIDE_ON_STARTUP 0x2

int bitsdojo_window_configure(unsigned int flags);

#if defined(__cplusplus)
}  // extern "C"
#endif

#endif  // FLUTTER_PLUGIN_BITSDOJO_WINDOW_PLUGIN_H_
