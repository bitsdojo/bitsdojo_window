#include "./api.h"

namespace bitsdojo_window {

BDWAPI _theAPI = {
    getAppWindowHandle,
    getScreenRect,
    getScaleFactor,
    getPosition,
    setPosition,
    getSize,
    setSize,
    setRect,
    setMinSize,
    setMaxSize,
    showWindow,
    hideWindow,
    minimizeWindow,
    maximizeWindow,
    unmaximizeWindow,
    setWindowTitle,
    setTopmost
};

} // namespace bitsdojo_window

BDW_EXPORT bitsdojo_window::BDWAPI* bitsdojo_window_api() {
    return &bitsdojo_window::_theAPI;
}