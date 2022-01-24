#ifndef BITSDOJO_WINDOW_H_
#define BITSDOJO_WINDOW_H_
#include <windows.h>

namespace bitsdojo_window {
    typedef bool (*TIsBitsdojoWindowLoaded)();
    bool isBitsdojoWindowLoaded();

    typedef void (*TSetWindowCanBeShown)(bool);
    void setWindowCanBeShown(bool value);

    typedef bool (*TDragAppWindow)();
    bool dragAppWindow();

    typedef HWND (*TGetAppWindow)();
    HWND getAppWindow();

    typedef void (*TSetMinSize)(int, int);
    void setMinSize(int width, int height);

    typedef void (*TSetMaxSize)(int, int);
    void setMaxSize(int width, int height);

    typedef void (*TSetWindowCutOnMaximize)(int);
    void setWindowCutOnMaximize(int value);

    typedef bool (*TIsDPIAware)();
    bool isDPIAware();
}
#endif