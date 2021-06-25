#include "./api_impl.h"
#include "./window_info.h"

namespace bitsdojo_window {

void getScreenRect(GtkWindow* window, int* x, int* y, int* width, int* height) {
    auto windowInfo = getWindowInfo(window);
    *x = windowInfo->screenX;
    *y = windowInfo->screenY;
    *width = windowInfo->screenWidth;
    *height = windowInfo->screenHeight;
}

void getScaleFactor(GtkWindow* window, int* scaleFactor) {
    auto windowInfo = getWindowInfo(window);
    *scaleFactor = windowInfo->scaleFactor;
}

void getPosition(GtkWindow* window, int* x, int* y) {
    auto windowInfo = getWindowInfo(window);
    *x = windowInfo->x;
    *y = windowInfo->y;
}

typedef struct SetPositionParams {
    GtkWindow* window;
    int x;
    int y;
} SetPositionParams;

gboolean setPositionProc(gpointer data) {
    SetPositionParams* params = static_cast<SetPositionParams*>(data);
    GdkWindow* gdw = gtk_widget_get_window(GTK_WIDGET(params->window));
    gdk_window_move(gdw, params->x, params->y);
    free(params);
    return FALSE;
}

void setPosition(GtkWindow* window, int x, int y) {
    SetPositionParams* params = new SetPositionParams();
    params->window = window;
    params->x = x;
    params->y = y;

    g_idle_add_full(G_PRIORITY_HIGH_IDLE, setPositionProc, params, NULL);
}

void getSize(GtkWindow* window, int* width, int* height) {
    auto windowInfo = getWindowInfo(window);
    *width = windowInfo->width;
    *height = windowInfo->height;
}

typedef struct SetSizeParams {
    GtkWindow* window;
    int width;
    int height;
} SetSizeParams;

gboolean setSizeProc(gpointer data) {
    SetSizeParams* params = static_cast<SetSizeParams*>(data);
    GdkWindow* gdw = gtk_widget_get_window(GTK_WIDGET(params->window));
    gdk_window_resize(gdw, params->width, params->height);
    free(params);
    return FALSE;
}

void setSize(GtkWindow* window, int width, int height) {
    SetSizeParams* params = new SetSizeParams();
    params->window = window;
    params->width = width;
    params->height = height;

    g_idle_add_full(G_PRIORITY_HIGH_IDLE, setSizeProc, params, NULL);
}

typedef struct SetRectParams {
    GtkWindow* window;
    int x;
    int y;
    int width;
    int height;
} SetRectParams;

gboolean setRectProc(gpointer data) {
    SetRectParams* params = static_cast<SetRectParams*>(data);
    GdkWindow* gdw = gtk_widget_get_window(GTK_WIDGET(params->window));
    gdk_window_move_resize(gdw, params->x, params->y, params->width,
                           params->height);
    free(params);
    return FALSE;
}

void setRect(GtkWindow* window, int x, int y, int width, int height) {
    SetRectParams* params = new SetRectParams();
    params->window = window;
    params->x = x;
    params->y = y;
    params->width = width;
    params->height = height;

    g_idle_add_full(G_PRIORITY_HIGH_IDLE, setRectProc, params, NULL);
}

void updateGeometry(GtkWindow* window, WindowInfo* windowInfo) {
    gint hints = 0;
    GdkGeometry geometry;

    geometry.min_width = windowInfo->minWidth;
    geometry.min_height = windowInfo->minHeight;
    geometry.max_width = windowInfo->maxWidth;
    geometry.max_height = windowInfo->maxHeight;

    if ((windowInfo->minWidth != -1) || (windowInfo->minHeight != -1)) {
        hints |= GDK_HINT_MIN_SIZE;
    }

    if ((windowInfo->maxWidth != -1) || (windowInfo->maxHeight != -1)) {
        hints |= GDK_HINT_MAX_SIZE;
    }

    gtk_window_set_geometry_hints(window, nullptr, &geometry,
                                  static_cast<GdkWindowHints>(hints));
}

void setMinSize(GtkWindow* window, int width, int height) {
    auto windowInfo = getWindowInfo(window);
    windowInfo->minWidth = width;
    windowInfo->minHeight = height;

    updateGeometry(window, windowInfo);
}

void setMaxSize(GtkWindow* window, int width, int height) {
    auto windowInfo = getWindowInfo(window);
    windowInfo->maxWidth = width;
    windowInfo->maxHeight = height;

    updateGeometry(window, windowInfo);
}

static gboolean showWindowProc(gpointer data) {
    GtkWindow* window = reinterpret_cast<GtkWindow*>(data);
    gtk_widget_show_all(GTK_WIDGET(window));
    return FALSE;
}

void showWindow(GtkWindow* window) {
    g_idle_add_full(G_PRIORITY_HIGH_IDLE, showWindowProc, window, NULL);
}

static gboolean hideWindowProc(gpointer data) {
    GtkWindow* window = reinterpret_cast<GtkWindow*>(data);
    gtk_widget_hide(GTK_WIDGET(window));
    return FALSE;
}

void hideWindow(GtkWindow* window) {
    g_idle_add_full(G_PRIORITY_HIGH_IDLE, hideWindowProc, window, NULL);
}

static gboolean minimizeWindowProc(gpointer data) {
    GtkWindow* window = reinterpret_cast<GtkWindow*>(data);
    gtk_window_iconify(window);
    return FALSE;
}

void minimizeWindow(GtkWindow* window) {
    g_idle_add_full(G_PRIORITY_HIGH_IDLE, minimizeWindowProc, window, NULL);
}

static gboolean maximizeWindowProc(gpointer data) {
    GtkWindow* window = reinterpret_cast<GtkWindow*>(data);
    gtk_window_maximize(window);
    return FALSE;
}

void maximizeWindow(GtkWindow* window) {
    g_idle_add_full(G_PRIORITY_HIGH_IDLE, maximizeWindowProc, window, NULL);
}

static gboolean unmaximizeWindowProc(gpointer data) {
    GtkWindow* window = reinterpret_cast<GtkWindow*>(data);
    gtk_window_unmaximize(window);
    return FALSE;
}

void unmaximizeWindow(GtkWindow* window) {
    g_idle_add_full(G_PRIORITY_HIGH_IDLE, unmaximizeWindowProc, window, NULL);
}

typedef struct SetWindowTitleParams {
    GtkWindow* window;
    const gchar* title;
} SetWindowTitleParams;

gboolean setWindowTitleProc(gpointer data) {
    SetWindowTitleParams* params = static_cast<SetWindowTitleParams*>(data);
    gtk_window_set_title(params->window, params->title);
    free((void*)params->title);
    free(params);
    return FALSE;
}

void setWindowTitle(GtkWindow* window, const gchar* title) {
    SetWindowTitleParams* params = new SetWindowTitleParams();
    params->window = window;
    params->title = title;
    g_idle_add_full(G_PRIORITY_HIGH_IDLE, setWindowTitleProc, params, NULL);
}

void setTopmost(GtkWindow* window, int topmost){
    gtk_window_set_keep_above(window,topmost == 1 ? TRUE : FALSE);
}

}  // namespace bitsdojo_window
