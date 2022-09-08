#include "bitsdojo_window_api.h"
#include "bitsdojo_window.h"
#include "bitsdojo_window_common.h"

namespace bitsdojo_window {
    BDWPrivateAPI privateAPI = {
        dragAppWindow,
    };

    BDWPublicAPI publicAPI = {
        isBitsdojoWindowLoaded,
        getAppWindow,
        setWindowCanBeShown,
        setMinSize,
        setMaxSize,
        setWindowCutOnMaximize,
        isDPIAware,
    };
}

BDWAPI bdwAPI = {
    &bitsdojo_window::publicAPI,
    &bitsdojo_window::privateAPI
};

BDW_EXPORT BDWAPI* bitsdojo_window_api(){
    return &bdwAPI;
}