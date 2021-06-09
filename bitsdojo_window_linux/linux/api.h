#ifndef _BDW_API_
#define _BDW_API_

#include "./common.h"
#include "./api_impl.h"

typedef GtkWindow* (*TGetAppWindowHandle)();
GtkWindow* getAppWindowHandle();

namespace bitsdojo_window {

typedef struct _BDWAPI {
    TGetAppWindowHandle getAppWindowHandle;
    TGetScreenRect getScreenRect;
    TGetScaleFactor getScaleFactor;
    TGetPosition getPosition;
    TSetPosition setPosition;
    TGetSize getSize;
    TSetSize setSize;
    TSetRect setRect;
    TSetMinSize setMinSize;
    TSetMaxSize setMaxSize;
    TShowWindow showWindow;
    THideWindow hideWindow;
    TMinimizeWindow minimizeWindow;
    TMaximizeWindow maximizeWindow;
    TUnmaximizeWindow unmaximizeWindow;
    TSetWindowTitle setWindowTitle;
} BDWAPI;

}  // namespace bitsdojo_window

BDW_EXPORT bitsdojo_window::BDWAPI* bitsdojo_window_api();

#endif // _BDW_API_