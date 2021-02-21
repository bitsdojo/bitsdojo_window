#ifndef BITSDOJO_WINDOW_API_H
#define BITSDOJO_WINDOW_API_H

typedef struct _BDWPublicAPI
{
    NSWindowResultFN getAppWindow;
    BoolParamFN setIsWindowReady;
    NSWindowParamFN showWindow;
    NSWindowParamFN moveWindow;
    NSWindowIntIntParamFN setSize;
    NSWindowIntIntParamFN setMinSize;
    NSWindowRectParamFN getScreenRectForWindow;
    NSWindowRectParamFN setRectForWindow;
    NSWindowRectParamFN getRectForWindow;
    IsWindowMaximizedFN isWindowMaximized;
    NSWindowParamFN maximizeWindow;
} BDWPublicAPI;

typedef struct _BDWPrivateAPI{
    BoolResultFN isWindowReady;
    NSWindowParamFN setAppWindow;
} BDWPrivateAPI;

typedef struct _BDWAPI{
    BDWPublicAPI* publicAPI;
    BDWPrivateAPI* privateAPI;
} BDWAPI;

OBJC_EXPORT BDWAPI* bitsdojo_window_api();

#endif /* BITSDOJO_WINDOW_API_H */
