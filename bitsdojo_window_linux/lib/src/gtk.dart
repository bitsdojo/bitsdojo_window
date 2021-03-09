import 'dart:ffi';
import 'package:ffi/ffi.dart';

final _libgtk = DynamicLibrary.open('libgtk-3.so');

final gtkWidgetGetParentWindow = _libgtk.lookupFunction<
    IntPtr Function(IntPtr widget),
    int Function(int widget)>('gtk_widget_get_parent_window');

final gtkWidgetShow = _libgtk.lookupFunction<IntPtr Function(IntPtr widget),
    int Function(int widget)>('gtk_widget_show');

final gtkWidgetHide = _libgtk.lookupFunction<IntPtr Function(IntPtr widget),
    int Function(int widget)>('gtk_widget_hide');

final gtkWindowGetScreen = _libgtk.lookupFunction<
    IntPtr Function(IntPtr window),
    int Function(int window)>('gtk_window_get_screen');

final gdkScreenGetDisplay = _libgtk.lookupFunction<
    IntPtr Function(IntPtr screen),
    int Function(int screen)>('gdk_screen_get_display');

final gdkDisplayGetPrimaryMonitor = _libgtk.lookupFunction<
    IntPtr Function(IntPtr display),
    int Function(int display)>('gdk_display_get_primary_monitor');

final gdkDisplayGetMonitorAtWindow = _libgtk.lookupFunction<
    IntPtr Function(IntPtr display, IntPtr window),
    int Function(int display, int window)>('gdk_display_get_monitor_at_window');

final gdkMonitorGetScaleFactor = _libgtk.lookupFunction<
    Int32 Function(IntPtr monitor),
    int Function(int monitor)>('gdk_monitor_get_scale_factor');

final gdkMonitorGetGeometry = _libgtk.lookupFunction<
    Int32 Function(IntPtr monitor, Pointer<Int32> rect),
    int Function(int monitor, Pointer<Int32> rect)>('gdk_monitor_get_geometry');

final gtkWindowGetPosition = _libgtk.lookupFunction<
    Void Function(IntPtr window, Pointer<Int32> x, Pointer<Int32> y),
    void Function(int window, Pointer<Int32> x,
        Pointer<Int32> y)>('gtk_window_get_position');

final gtkWindowGetSize = _libgtk.lookupFunction<
    Void Function(IntPtr window, Pointer<Int32> x, Pointer<Int32> y),
    void Function(
        int window, Pointer<Int32> x, Pointer<Int32> y)>('gtk_window_get_size');

final gtkWindowMove = _libgtk.lookupFunction<
    Void Function(IntPtr window, Int32 x, Int32 y),
    void Function(int window, int x, int y)>('gtk_window_move');

final gtkWindowResize = _libgtk.lookupFunction<
    Void Function(IntPtr window, Int32 width, Int32 height),
    void Function(int window, int width, int height)>('gtk_window_resize');

final gtkWindowClose = _libgtk.lookupFunction<Void Function(IntPtr window),
    void Function(int window)>('gtk_window_close');

final gtkWindowIsMaximized = _libgtk.lookupFunction<
    Int32 Function(IntPtr window),
    int Function(int window)>('gtk_window_is_maximized');

final gtkWindowMaximize = _libgtk.lookupFunction<Void Function(IntPtr window),
    void Function(int window)>('gtk_window_maximize');

final gtkWindowUnmaximize = _libgtk.lookupFunction<Void Function(IntPtr window),
    void Function(int window)>('gtk_window_unmaximize');

final gtkWindowIconify = _libgtk.lookupFunction<Void Function(IntPtr window),
    void Function(int window)>('gtk_window_iconify');

final gtkWindowDeiconify = _libgtk.lookupFunction<Void Function(IntPtr window),
    void Function(int window)>('gtk_window_deiconify');

final gtkWindowSetTitle = _libgtk.lookupFunction<
    Void Function(IntPtr window, Pointer<Utf8> title),
    void Function(int window, Pointer<Utf8> title)>('gtk_window_set_title');
