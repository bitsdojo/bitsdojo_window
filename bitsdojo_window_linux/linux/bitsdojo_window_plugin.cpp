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
#include "include/bitsdojo_window_linux/bitsdojo_window_plugin.h"

#include <cmath>
#include <flutter_linux/flutter_linux.h>
#include <gtk/gtk.h>
#include <glib-object.h>

const char kChannelName[] = "bitsdojo/window";
const char kDragAppWindowMethod[] = "dragAppWindow";

struct _FlBitsdojoWindowPlugin {
  GObject parent_instance;

  FlPluginRegistrar* registrar;

  // Connection to Flutter engine.
  FlMethodChannel* channel;
};

G_DEFINE_TYPE(FlBitsdojoWindowPlugin, bitsdojo_window_plugin, g_object_get_type())

FlBitsdojoWindowPlugin *pluginInst = nullptr;
unsigned int configurationFlags = 0;

// Gets the window being controlled.
GtkWindow* get_window(FlBitsdojoWindowPlugin* self) {
  FlView* view = fl_plugin_registrar_get_view(self->registrar);
  if (view == nullptr) return nullptr;

  GtkWindow* window = GTK_WINDOW(gtk_widget_get_toplevel(GTK_WIDGET(view)));
  return window;
}

static FlMethodResponse* start_window_drag_at_position(FlBitsdojoWindowPlugin *self, FlValue *args) {
	auto window = get_window(self);
	auto screen = gtk_window_get_screen(window);
	auto display = gdk_screen_get_display(screen);
	auto seat = gdk_display_get_default_seat(display);
	auto device = gdk_seat_get_pointer(seat);

	gint x, y;
	gdk_device_get_position(device, nullptr, &x, &y);

	gtk_window_begin_move_drag(window,
			1,
			x, y,
			(guint32)g_get_monotonic_time()
			);

	gtk_widget_grab_focus(GTK_WIDGET(fl_plugin_registrar_get_view(self->registrar)));

	return FL_METHOD_RESPONSE(fl_method_success_response_new(nullptr));
}

// Called when a method call is received from Flutter.
static void method_call_cb(FlMethodChannel* channel, FlMethodCall* method_call,
                           gpointer user_data) {
  FlBitsdojoWindowPlugin* self = FL_BITSDOJO_WINDOW_PLUGIN(user_data);

  const gchar* method = fl_method_call_get_name(method_call);
  FlValue* args = fl_method_call_get_args(method_call);

  g_autoptr(FlMethodResponse) response = nullptr;
  if (strcmp(method, kDragAppWindowMethod) == 0) {
    response = start_window_drag_at_position(self, args);
  } else {
    response = FL_METHOD_RESPONSE(fl_method_not_implemented_response_new());
  }

  g_autoptr(GError) error = nullptr;
  if (!fl_method_call_respond(method_call, response, &error))
    g_warning("Failed to send method call response: %s", error->message);
}

static void bitsdojo_window_plugin_dispose(GObject* object) {
  FlBitsdojoWindowPlugin* self = FL_BITSDOJO_WINDOW_PLUGIN(object);

  g_clear_object(&self->registrar);
  g_clear_object(&self->channel);

  G_OBJECT_CLASS(bitsdojo_window_plugin_parent_class)->dispose(object);
}

static void bitsdojo_window_plugin_class_init(FlBitsdojoWindowPluginClass* klass) {
  G_OBJECT_CLASS(klass)->dispose = bitsdojo_window_plugin_dispose;
}

static void bitsdojo_window_plugin_init(FlBitsdojoWindowPlugin* self) {
	pluginInst = self;
}

FlBitsdojoWindowPlugin* bitsdojo_window_plugin_new(FlPluginRegistrar* registrar) {
  FlBitsdojoWindowPlugin* self = FL_BITSDOJO_WINDOW_PLUGIN(
      g_object_new(bitsdojo_window_plugin_get_type(), nullptr));

  self->registrar = FL_PLUGIN_REGISTRAR(g_object_ref(registrar));

  g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();
  self->channel =
      fl_method_channel_new(fl_plugin_registrar_get_messenger(registrar),
                            kChannelName, FL_METHOD_CODEC(codec));
  fl_method_channel_set_method_call_handler(self->channel, method_call_cb,
                                            g_object_ref(self), g_object_unref);

  return self;
}

void bitsdojo_window_plugin_register_with_registrar(FlPluginRegistrar* registrar) {
  FlBitsdojoWindowPlugin* plugin = bitsdojo_window_plugin_new(registrar);
  g_object_unref(plugin);
}

int bitsdojo_window_configure(unsigned int flags) {
	configurationFlags = flags;
	return 1;
}

