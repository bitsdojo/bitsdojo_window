#import "bitsdojo_window.h"
#import "bitsdojo_window_api.h"

BDWPrivateAPI privateAPI = {
    windowCanBeShown,
    setAppWindow
};

BDWPublicAPI publicAPI = {
    getAppWindow,
    setWindowCanBeShown,
    setInsideDoWhenWindowReady,
    showWindow,
    hideWindow,
    moveWindow,
    setSize,
    setMinSize,
    setMaxSize,
    getScreenInfoForWindow,
    setPositionForWindow,
    setRectForWindow,
    getRectForWindow,
    isWindowVisible,
    isWindowMaximized,
    maximizeOrRestoreWindow,
    maximizeWindow,
    minimizeWindow,
    closeWindow,
    setWindowTitle,
    getTitleBarHeight
};

BDWAPI bdwAPI = {
    &publicAPI,
    &privateAPI,
};

BDW_EXPORT BDWAPI* bitsdojo_window_api(){
    return &bdwAPI;
}
