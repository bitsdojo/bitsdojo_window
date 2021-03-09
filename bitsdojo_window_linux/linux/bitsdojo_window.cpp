#include "bitsdojo_window.h"

#include <cinttypes>
#include <flutter_linux/flutter_linux.h>
#include <gtk/gtk.h>

#include "include/bitsdojo_window_linux/bitsdojo_window_plugin.h"

extern FlBitsdojoWindowPlugin *pluginInst;

BDW_API void bitsdojo_window_setMinSize(int width, int height) {
	GdkGeometry geometry;
	geometry.min_width = width;
	geometry.min_height = height;

	gtk_window_set_geometry_hints(
			get_window(pluginInst),
			nullptr,
			&geometry,
			static_cast<GdkWindowHints>(GDK_HINT_MIN_SIZE));
}

BDW_API void bitsdojo_window_setMaxSize(int width, int height) {
	GdkGeometry geometry;
	geometry.max_width = width;
	geometry.max_height = height;

	gtk_window_set_geometry_hints(
			get_window(pluginInst),
			nullptr,
			&geometry,
			static_cast<GdkWindowHints>(GDK_HINT_MAX_SIZE));
}

BDW_API uint8_t bitsdojo_window_getAppState() {
	return 2;
}

BDW_API void bitsdojo_window_setAppState(uint8_t appState) {
}

BDW_API GtkWindow* bitsdojo_window_getFlutterWindow() {
	return get_window(pluginInst);
}

BDW_API GdkWindow* bitsdojo_window_getFlutterGdkWindow() {
	return gtk_widget_get_parent_window(GTK_WIDGET(get_window(pluginInst)));
}
