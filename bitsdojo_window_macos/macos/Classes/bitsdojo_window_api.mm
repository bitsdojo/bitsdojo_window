#import "bitsdojo_window.h"
#import "bitsdojo_window_api.h"

BDWPrivateAPI privateAPI = {
    isWindowReady,
    setAppWindow
};


BDWPublicAPI publicAPI = {
    getAppWindow,
    setIsWindowReady,
    showWindow,
    moveWindow,
    setSize,
    setMinSize,
    getScreenRectForWindow,
    setRectForWindow,
    getRectForWindow,
    isWindowMaximized,
    maximizeWindow
};

BDWAPI bdwAPI = {
    &publicAPI,
    &privateAPI,
};

OBJC_EXPORT BDWAPI* bitsdojo_window_api(){
    return &bdwAPI;
}
