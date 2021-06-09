// Copyright 2018 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
#ifndef FLUTTER_PLUGIN_BITSDOJO_WINDOW_PLUGIN_H_
#define FLUTTER_PLUGIN_BITSDOJO_WINDOW_PLUGIN_H_

// A plugin to allow resizing the window.

#include <flutter_linux/flutter_linux.h>

G_BEGIN_DECLS

#if !defined(BDW_VISIBLE)
    #define BDW_VISIBLE  __attribute__((visibility("default")))
#endif

#ifdef FLUTTER_PLUGIN_IMPL
#define FLUTTER_PLUGIN_EXPORT __attribute__((visibility("default")))
#else
#define FLUTTER_PLUGIN_EXPORT
#endif

G_DECLARE_FINAL_TYPE(FlBitsdojoWindowPlugin, bitsdojo_window_plugin, FL,
                     BITSDOJO_WINDOW_PLUGIN, GObject)

FLUTTER_PLUGIN_EXPORT FlBitsdojoWindowPlugin* bitsdojo_window_plugin_new(
    FlPluginRegistrar* registrar);

FLUTTER_PLUGIN_EXPORT void bitsdojo_window_plugin_register_with_registrar(
    FlPluginRegistrar* registrar);

class BitsdojoWindowGtk {
public:
    virtual void setCustomFrame(gboolean){};
};

BDW_VISIBLE BitsdojoWindowGtk* bitsdojo_window_from(GtkWindow* window);

G_END_DECLS

#endif  // FLUTTER_PLUGIN_BITSDOJO_WINDOW_PLUGIN_H_
