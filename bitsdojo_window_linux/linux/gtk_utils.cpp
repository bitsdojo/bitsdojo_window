#include "./gtk_utils.h"

namespace bitsdojo_window {

void gtk_container_children_callback(GtkWidget *widget, gpointer client_data) {
    GList **children;
    children = (GList **)client_data;
    *children = g_list_prepend(*children, widget);
}

GList *gtk_container_get_all_children(GtkContainer *container) {
    GList *children = NULL;
    gtk_container_forall(container, gtk_container_children_callback, &children);
    return children;
}

GdkCursorType edgeToCursor(GdkWindowEdge edge) {
    switch (edge) {
        case GDK_WINDOW_EDGE_NORTH_WEST:
            return GDK_TOP_LEFT_CORNER;
        case GDK_WINDOW_EDGE_NORTH:
            return GDK_TOP_SIDE;
        case GDK_WINDOW_EDGE_NORTH_EAST:
            return GDK_TOP_RIGHT_CORNER;
        case GDK_WINDOW_EDGE_WEST:
            return GDK_LEFT_SIDE;
        case GDK_WINDOW_EDGE_EAST:
            return GDK_RIGHT_SIDE;
        case GDK_WINDOW_EDGE_SOUTH_WEST:
            return GDK_BOTTOM_LEFT_CORNER;
        case GDK_WINDOW_EDGE_SOUTH:
            return GDK_BOTTOM_SIDE;
        case GDK_WINDOW_EDGE_SOUTH_EAST:
            return GDK_BOTTOM_RIGHT_CORNER;
        default:
            return GDK_LAST_CURSOR;
    }
    return GDK_LAST_CURSOR;
}

const gchar *getCursorForEdge(GdkWindowEdge edge) {
    switch (edge) {
        case GDK_WINDOW_EDGE_NORTH_WEST:
            return "nw-resize";
        case GDK_WINDOW_EDGE_NORTH:
            return "n-resize";
        case GDK_WINDOW_EDGE_NORTH_EAST:
            return "ne-resize";
        case GDK_WINDOW_EDGE_EAST:
            return "e-resize";
        case GDK_WINDOW_EDGE_SOUTH_EAST:
            return "se-resize";
        case GDK_WINDOW_EDGE_SOUTH:
            return "s-resize";
        case GDK_WINDOW_EDGE_SOUTH_WEST:
            return "sw-resize";
        case GDK_WINDOW_EDGE_WEST:
            return "w-resize";
        default:
            return "default";
    }
}

bool getWindowEdge(int width, int height, gdouble x, double y,
                   GdkWindowEdge *edge, int margin) {
    if (x < margin) {
        if (y < margin) {
            *edge = GDK_WINDOW_EDGE_NORTH_WEST;
        } else if (y < height - margin) {
            *edge = GDK_WINDOW_EDGE_WEST;
        } else {
            *edge = GDK_WINDOW_EDGE_SOUTH_WEST;
        }
        return true;
    } else if (x > width - margin) {
        if (y < margin) {
            *edge = GDK_WINDOW_EDGE_NORTH_EAST;
        } else if (y < height - margin) {
            *edge = GDK_WINDOW_EDGE_EAST;
        } else {
            *edge = GDK_WINDOW_EDGE_SOUTH_EAST;
        }
        return true;
    } else {
        if (y < margin) {
            *edge = GDK_WINDOW_EDGE_NORTH;
        } else if (y < height - margin) {
            return false;
        } else {
            *edge = GDK_WINDOW_EDGE_SOUTH;
        }
        return true;
    }
    return false;
}

void getMousePositionOnScreen(GtkWindow *window, gint *x, gint *y) {
    auto screen = gtk_window_get_screen(window);
    auto display = gdk_screen_get_display(screen);
    auto seat = gdk_display_get_default_seat(display);
    auto device = gdk_seat_get_pointer(seat);
    gdk_device_get_position(device, nullptr, x, y);
}

void getScreenRectForWindow(GtkWindow *window, GdkRectangle *rect) {
    GdkWindow *gdw = gtk_widget_get_window(GTK_WIDGET(window));
    GdkScreen *screen = gtk_window_get_screen(window);
    GdkDisplay *display = gdk_screen_get_display(screen);
    GdkMonitor *monitor = gdk_display_get_monitor_at_window(display, gdw);
    gdk_monitor_get_geometry(monitor, rect);
}

void getScaleFactorForWindow(GtkWindow *window, gint *scaleFactor) {
    GdkWindow *gdw = gtk_widget_get_window(GTK_WIDGET(window));
    GdkScreen *screen = gtk_window_get_screen(window);
    GdkDisplay *display = gdk_screen_get_display(screen);
    GdkMonitor *monitor = gdk_display_get_monitor_at_window(display, gdw);
    *scaleFactor = gdk_monitor_get_scale_factor(monitor);
}

    void emitMouseMoveEvent(GtkWidget* widget, int x, int y) {
        auto event = (GdkEventButton *)gdk_event_new(GDK_MOTION_NOTIFY);
        event->type = GDK_MOTION_NOTIFY;
        event->x = x;
        event->y = y;
        event->time = g_get_monotonic_time();
        gboolean result;
        g_signal_emit_by_name(widget, "motion-notify-event", event, &result);
        gdk_event_free((GdkEvent *)event);
    }

}  // namespace bitsdojo_window