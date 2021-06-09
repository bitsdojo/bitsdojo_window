#ifndef _BDW_WINDOW_INFO_
#define _BDW_WINDOW_INFO_

#include <gtk/gtk.h>

namespace bitsdojo_window {
    typedef struct _WindowInfo{
        int x;
        int y;
        int width;
        int height;
        int screenX;
        int screenY;
        int screenWidth;
        int screenHeight;
        int minWidth;
        int minHeight;
        int maxWidth;
        int maxHeight;
        int scaleFactor;
        int gripSize;
    } WindowInfo;

    WindowInfo* getWindowInfo(GtkWindow *window);
}
#endif //_BDW_WINDOW_INFO_