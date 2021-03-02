#ifndef BITSDOJO_WINDOW_API_H
#define BITSDOJO_WINDOW_API_H

#include "./bitsdojo_window.h"
#include "./bitsdojo_window_common.h"

typedef struct _BDWPublicAPI
{
    TGetAppWindow getAppWindow;
    TSetWindowCanBeShown setWindowCanBeShown;
    TSetInsideDoWhenWindowReady setInsideDoWhenWindowReady;
    TShowWindow showWindow;
    THideWindow hideWindow;
    TMoveWindow moveWindow;
    TSetSize setSize;
    TSetMinSize setMinSize;
    TSetMaxSize setMaxSize;
    TGetScreenInfoForWindow getScreenInfoForWindow;
    TSetPositionForWindow setPositionForWindow;
    TSetRectForWindow setRectForWindow;
    TGetRectForWindow getRectForWindow;
    TIsWindowMaximized isWindowVisible;
    TIsWindowMaximized isWindowMaximized;
    TMaximizeOrRestoreWindow maximizeOrRestoreWindow;
    TMaximizeWindow maximizeWindow;
    TMinimizeWindow minimizeWindow;
    TCloseWindow closeWindow;
    TSetWindowTitle setWindowTitle;
    TGetTitleBarHeight getTitleBarHeight;
} BDWPublicAPI;

typedef struct _BDWPrivateAPI{
    TWindowCanBeShown windowCanBeShown;
    TSetAppWindow setAppWindow;
} BDWPrivateAPI;

typedef struct _BDWAPI{
    BDWPublicAPI* publicAPI;
    BDWPrivateAPI* privateAPI;
} BDWAPI;

BDW_EXPORT BDWAPI* bitsdojo_window_api();

#endif /* BITSDOJO_WINDOW_API_H */
