#include <glib.h>
#include "./window_info.h"

namespace bitsdojo_window {

GHashTable* windows_table = nullptr;

WindowInfo* getWindowInfo(GtkWindow* window) {
    if (nullptr == windows_table) {
        windows_table = g_hash_table_new(g_int_hash, g_int_equal);
    }
    WindowInfo* windowInfo;
    windowInfo = reinterpret_cast<WindowInfo*>(
        g_hash_table_lookup(windows_table, window));
    if (nullptr != windowInfo) {
        return windowInfo;
    }

    windowInfo = new WindowInfo();
    windowInfo->minWidth = -1;
    windowInfo->minHeight = -1;
    windowInfo->maxWidth = -1;
    windowInfo->maxHeight = -1;
    windowInfo->gripSize = 6;
    g_hash_table_insert(windows_table, window, windowInfo);
    return windowInfo;
}

}  // namespace bitsdojo_window