#ifndef _BDW_GTK_UTILS_
#define _BDW_GTK_UTILS_
#include <gdk/gdk.h>
#include <gtk/gtk.h>

namespace bitsdojo_window {
    GList* gtk_container_get_all_children(GtkContainer* container);
    GdkCursorType edgeToCursor(GdkWindowEdge edge);
    const gchar* getCursorForEdge(GdkWindowEdge edge);
    bool getWindowEdge(int width, int height, gdouble x, double y,
                    GdkWindowEdge* edge, int margin);
    void getMousePositionOnScreen(GtkWindow* window, gint* x, gint* y);
    void getScreenRectForWindow(GtkWindow* window, GdkRectangle* rect);
    void getScaleFactorForWindow(GtkWindow* window, gint* scaleFactor);
    void emitMouseMoveEvent(GtkWidget* widget, int x, int y);
}  // namespace bitsdojo_window

#endif  // _BDW_GTK_UTILS_