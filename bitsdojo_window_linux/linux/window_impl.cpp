#include <gdk/gdk.h>
#include <gtk/gtk.h>

#include "./debug_helper.h"
#include "./gtk_utils.h"
#include "./window_info.h"
#include "include/bitsdojo_window_linux/bitsdojo_window_plugin.h"

namespace bitsdojo_window {

static gboolean onMouseMoveHook(GSignalInvocationHint *ihint,
                                guint n_param_values,
                                const GValue *param_values, gpointer data);

static gboolean onMousePressHook(GSignalInvocationHint *ihint,
                                 guint n_param_values,
                                 const GValue *param_values, gpointer data);

static gboolean onMouseReleaseHook(GSignalInvocationHint *ihint,
                                   guint n_param_values,
                                   const GValue *param_values, gpointer data);

class BitsdojoWindowImpl : BitsdojoWindowGtk {
   public:
    GtkWindow *handle = nullptr;
    GtkWidget *event_box = nullptr;
    GdkWindowEdge currentEdge;
    gboolean isOnEdge = false;
    gboolean isMaximized = false;
    gboolean isDragging = false;
    gboolean isResizing = false;
    GdkEventButton currentPressedEvent = GdkEventButton{};
    gulong flutterButtonPressHandler = 0;
    gboolean isFlutterButtonPressBlocked = false;
    gulong mouseMoveHookID = 0;
    gulong mousePressHookID = 0;
    gulong mouseReleaseHookId = 0;
    WindowInfo *_windowInfo = nullptr;

    BitsdojoWindowImpl() {}

    WindowInfo* _getWindowInfo() {
        if (nullptr == _windowInfo) {
            _windowInfo = bitsdojo_window::getWindowInfo(this->handle);
        }
        return _windowInfo;
    }

    void blockButtonPress() {
        if (0 == flutterButtonPressHandler) {
            flutterButtonPressHandler = g_signal_handler_find(
                event_box, G_SIGNAL_MATCH_ID,
                g_signal_lookup("button-press-event", GTK_TYPE_WIDGET), 0, NULL,
                NULL, NULL);
        }

        if (isFlutterButtonPressBlocked) {
            return;
        }
        g_signal_handler_block(event_box, flutterButtonPressHandler);
        isFlutterButtonPressBlocked = true;
    }

    void unblockButtonPress() {
        if (!isFlutterButtonPressBlocked) {
            return;
        }
        isFlutterButtonPressBlocked = false;
        g_signal_handler_unblock(event_box, flutterButtonPressHandler);
    }

    void updateEdge(int x, int y) {
        GdkWindowEdge edge = this->currentEdge;
        auto windowInfo = _getWindowInfo();

        int width = windowInfo->width;
        int height = windowInfo->height;
        auto isOnEdge =
            getWindowEdge(width, height, x, y, &edge, windowInfo->gripSize);
        auto isMaximized = gtk_window_is_maximized(this->handle);

        if ((edge != this->currentEdge) || (isOnEdge != this->isOnEdge) ||
            (isMaximized != this->isMaximized)) {
            this->isMaximized = isMaximized;
            this->isOnEdge = isOnEdge;
            this->currentEdge = edge;
            this->updateMouseCursor();
        }
    }

    void resetMouseCursor() {
        GdkWindow *gdw = gtk_widget_get_window(GTK_WIDGET(this->handle));
        GdkCursor *cursor =
            gdk_cursor_new_from_name(gdk_window_get_display(gdw), "default");
        gdk_window_set_cursor(gdw, cursor);
        g_object_unref(cursor);
    }

    void updateMouseCursor() {
        auto cursor_name = (isOnEdge && !isMaximized)
                               ? getCursorForEdge(currentEdge)
                               : "default";
        GdkWindow *gdw = gtk_widget_get_window(GTK_WIDGET(this->handle));
        GdkCursor *cursor =
            gdk_cursor_new_from_name(gdk_window_get_display(gdw), cursor_name);
        gdk_window_set_cursor(gdw, cursor);
        g_object_unref(cursor);
    }

    void getMousePositionInsideWindow(gint *x, gint *y) {
        getMousePositionOnScreen(this->handle, x, y);
        auto windowInfo = _getWindowInfo();
        *x = *x - windowInfo->x;
        *y = *y - windowInfo->y;
    }

    void setCustomFrame(gboolean value) {
        if (false == value) {
            return;
        }
        auto window = this->handle;
        auto screen = gtk_window_get_screen(window);
        gtk_window_set_decorated(window, FALSE);
        auto rgba = gdk_screen_get_rgba_visual(screen);
        if (rgba && gdk_screen_is_composited(screen)) {
            gtk_widget_set_visual(GTK_WIDGET(window), rgba);
        }

        auto *backgroundStyle = gtk_css_provider_new();
        gtk_css_provider_load_from_data(GTK_CSS_PROVIDER(backgroundStyle),
                                        "window {\n"
                                        "   background:none;\n"
                                        "}\n",
                                        -1, NULL);
        gtk_style_context_add_provider_for_screen(
            screen, GTK_STYLE_PROVIDER(backgroundStyle),
            GTK_STYLE_PROVIDER_PRIORITY_APPLICATION);
        g_object_unref(backgroundStyle);
    }

    void addHooks() {
        mouseMoveHookID = g_signal_add_emission_hook(
            g_signal_lookup("motion-notify-event", GTK_TYPE_WIDGET), 0,
            onMouseMoveHook, this, NULL);
        mousePressHookID = g_signal_add_emission_hook(
            g_signal_lookup("button-press-event", GTK_TYPE_WIDGET), 0,
            onMousePressHook, this, NULL);
        mouseReleaseHookId = g_signal_add_emission_hook(
            g_signal_lookup("button-release-event", GTK_TYPE_WIDGET), 0,
            onMouseReleaseHook, this, NULL);
    }

    void findEventBox(GtkWidget *widget) {
        GList *children;
        GtkWidget *currentChild;
        children = gtk_container_get_all_children(GTK_CONTAINER(widget));
        while (children) {
            currentChild = (GtkWidget *)children->data;
            if (GTK_IS_EVENT_BOX(currentChild)) {
                this->event_box = currentChild;
                this->addHooks();
            }
            children = children->next;
        }
    }
};

static gboolean onMousePressHook(GSignalInvocationHint *ihint,
                                 guint n_param_values,
                                 const GValue *param_values, gpointer data) {
    auto self = reinterpret_cast<BitsdojoWindowImpl *>(data);

    gpointer instance = g_value_peek_pointer(param_values);

    if (!GTK_IS_EVENT_BOX(instance)) {
        return TRUE;
    }

    GdkEventButton *event =
        (GdkEventButton *)(g_value_get_boxed(param_values + 1));

    if (self->isOnEdge && !self->isMaximized) {
        self->blockButtonPress();
        self->isResizing = true;
        gtk_window_begin_resize_drag(
            self->handle, self->currentEdge, event->button,
            static_cast<gint>(event->x_root), static_cast<gint>(event->y_root),
            event->time);
    }
    memset(&self->currentPressedEvent, 0, sizeof(self->currentPressedEvent));
    memcpy(&self->currentPressedEvent, event,
           sizeof(self->currentPressedEvent));
    return TRUE;
}

static gboolean onMouseReleaseHook(GSignalInvocationHint *ihint,
                                   guint n_param_values,
                                   const GValue *param_values, gpointer data) {
    auto self = reinterpret_cast<BitsdojoWindowImpl *>(data);

    gpointer instance = g_value_peek_pointer(param_values);

    if (!GTK_IS_EVENT_BOX(instance)) {
        return TRUE;
    }
    // GdkEventButton *event = (GdkEventButton*)(g_value_get_boxed(param_values
    // + 1));
    self->unblockButtonPress();

    return TRUE;
}

static gboolean onMouseMoveHook(GSignalInvocationHint *ihint,
                                guint n_param_values,
                                const GValue *param_values, gpointer data) {
    auto self = reinterpret_cast<BitsdojoWindowImpl *>(data);

    gpointer instance = g_value_peek_pointer(param_values);

    if (!GTK_IS_EVENT_BOX(instance)) {
        return TRUE;
    }

    GdkEventMotion *event =
        (GdkEventMotion *)(g_value_get_boxed(param_values + 1));
    if (!event) return TRUE;
    self->updateEdge(event->x, event->y);
    return TRUE;
}

BitsdojoWindowImpl *_appWindow = nullptr;

BitsdojoWindowImpl *getAppWindowInstance() {
    if (_appWindow == nullptr) {
        _appWindow = new BitsdojoWindowImpl;
    }

    return _appWindow;
}

static gboolean onWindowEventAfter(GtkWidget *text_view, GdkEvent *event,
                                   BitsdojoWindowImpl *self) {
    if (event->type == GDK_ENTER_NOTIFY) {
        if (nullptr == self->event_box) {
            return FALSE;
        }
        if (self->isDragging) {
            self->isDragging = false;
            auto newEvent = (GdkEventButton *)gdk_event_new(GDK_BUTTON_RELEASE);
            newEvent->x = self->currentPressedEvent.x;
            newEvent->y = self->currentPressedEvent.y;
            newEvent->button = self->currentPressedEvent.button;
            newEvent->type = GDK_BUTTON_RELEASE;
            newEvent->time = g_get_monotonic_time();
            gboolean result;
            g_signal_emit_by_name(self->event_box, "button-release-event",
                                  newEvent, &result);
            gdk_event_free((GdkEvent *)newEvent);
        }
        if (self->isResizing) {
            self->isResizing = false;
        }
        self->unblockButtonPress();
        gint x, y;
        self->getMousePositionInsideWindow(&x, &y);
        emitMouseMoveEvent(self->event_box,x, y);
    } else if (event->type == GDK_LEAVE_NOTIFY) {
        emitMouseMoveEvent(self->event_box,-1, -1);
    } else {
        // bitsdojo_window::printGdkEvent("event after", event->type);
    }
    return FALSE;
}

gboolean onWindowSizeMove(GtkWidget *widget, GdkEventConfigure *event,
                          BitsdojoWindowImpl *self) {
    auto windowInfo = self->_getWindowInfo();
    windowInfo->x = event->x;
    windowInfo->y = event->y;
    windowInfo->width = event->width;
    windowInfo->height = event->height;
    GdkRectangle screenRectangle;
    getScreenRectForWindow(GTK_WINDOW(widget), &screenRectangle);
    windowInfo->screenX = screenRectangle.x;
    windowInfo->screenY = screenRectangle.y;
    windowInfo->screenWidth = screenRectangle.width;
    windowInfo->screenHeight = screenRectangle.height;
    int scaleFactor = 0;
    getScaleFactorForWindow(self->handle, &scaleFactor);
    windowInfo->scaleFactor = scaleFactor;

    return FALSE;
}

}  // namespace bitsdojo_window

BitsdojoWindowGtk *bitsdojo_window_from(GtkWindow *window) {
    auto appWindow = bitsdojo_window::getAppWindowInstance();
    appWindow->handle = window;
    return reinterpret_cast<BitsdojoWindowGtk *>(appWindow);
}

void enhanceFlutterView(GtkWidget *flutterView) {
    auto appWindow = bitsdojo_window::getAppWindowInstance();
    auto topLevelWindow = GTK_WINDOW(gtk_widget_get_toplevel(flutterView));
    appWindow->handle = topLevelWindow;
    g_signal_connect(topLevelWindow, "event-after",
                     G_CALLBACK(bitsdojo_window::onWindowEventAfter),
                     appWindow);
    g_signal_connect(topLevelWindow, "configure-event",
                     G_CALLBACK(bitsdojo_window::onWindowSizeMove), appWindow);
    appWindow->findEventBox(flutterView);
}

void startWindowDrag(GtkWindow *window) {
    gint x, y;
    bitsdojo_window::getMousePositionOnScreen(window, &x, &y);
    auto appWindow = bitsdojo_window::getAppWindowInstance();
    if (appWindow->handle == window) {
        appWindow->isDragging = true;
    }

    gtk_window_begin_move_drag(window, 1, x, y,
                               (guint32)g_get_monotonic_time());
}