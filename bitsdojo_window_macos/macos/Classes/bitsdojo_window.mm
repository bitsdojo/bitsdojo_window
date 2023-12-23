#import "bitsdojo_window.h"
#import "bitsdojo_window_controller.h"

NSWindow* _appWindow = NULL;
bool _windowCanBeShown = false;
bool _insideDoWhenWindowReady = false;
BitsdojoWindowController *controller = NULL;

void setInsideDoWhenWindowReady(bool value) {
    _insideDoWhenWindowReady = value;
}

bool appWindowIsSet() {
    return _appWindow != NULL;
}

void setAppWindow(NSWindow* value) {
    _appWindow = value;
    controller = [[BitsdojoWindowController alloc] initWithWindow:value];
}

NSWindow* getAppWindow() {
    if (_appWindow == NULL) {
        _appWindow = [NSApp windows][0];
    }
    return _appWindow;
}

bool windowCanBeShown() {
    return _windowCanBeShown;
}

void setWindowCanBeShown(bool value) {
    _windowCanBeShown = value;
}
void runOnMainThread(dispatch_block_t block) {
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

void showWindow(NSWindow* window) {
    setWindowCanBeShown(true);
    runOnMainThread(^{
        if (![[NSApplication sharedApplication] isActive]) {
            [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
        }
        [window makeKeyAndOrderFront:nil];
    });
}

void hideWindow(NSWindow* window) {
    runOnMainThread(^{
        [window setIsVisible:FALSE];
    });
}

void moveWindow(NSWindow* window) {
    runOnMainThread(^{
        [window performWindowDragWithEvent:[window currentEvent]];
    });
}

void setSize(NSWindow* window, int width, int height) {
    NSRect frame = [window frame];
    frame.size.width = width;
    frame.size.height = height;
    runOnMainThread(^{
        [window setFrame:frame display:true];
    });
}

void setMinSize(NSWindow* window, int width, int height) {
    NSSize minSize;
    minSize.width = width;
    minSize.height = height;
    runOnMainThread(^{
        [window setMinSize:minSize];
    });
}

void setMaxSize(NSWindow* window, int width, int height) {
    NSSize maxSize;
    maxSize.width = width;
    maxSize.height = height;
    runOnMainThread(^{
        [window setMaxSize:maxSize];
    });
}

BDWStatus getScreenInfoForWindow(NSWindow* window, BDWScreenInfo *screenInfo) {
    auto workingScreenRect = controller.workingScreenRect;
    auto fullScreenRect = controller.fullScreenRect;
    auto menuBarHeight = fullScreenRect.size.height - workingScreenRect.size.height - workingScreenRect.origin.y;
    BDWRect* workingRect = screenInfo->workingRect;
    BDWRect* fullRect = screenInfo->fullRect;
    workingRect->top = menuBarHeight;
    workingRect->left = workingScreenRect.origin.x;
    workingRect->bottom = workingRect->top + workingScreenRect.size.height;
    workingRect->right = workingRect->left + workingScreenRect.size.width;
    fullRect->left = fullScreenRect.origin.x;
    fullRect->right = fullRect->left + fullScreenRect.size.width;
    fullRect->top = fullScreenRect.origin.y;
    fullRect->bottom = fullRect->top + fullScreenRect.size.height;
    return BDW_SUCCESS;
}

BDWStatus setPositionForWindow(NSWindow* window, BDWOffset* offset) {
    runOnMainThread(^{
        NSPoint position;
        auto screen = [window screen];
        auto fullScreenRect = [screen visibleFrame];
        position.x = offset->x;
        position.y = fullScreenRect.origin.y + fullScreenRect.size.height - offset->y;
        [window setFrameTopLeftPoint:position];
    });
    return BDW_SUCCESS;
}

BDWStatus setRectForWindow(NSWindow* window, BDWRect* rect) {
    setWindowCanBeShown(true);
    NSRect fullScreenRect = controller.fullScreenRect;
    NSRect frame;
    frame.size.width = rect->right - rect->left;
    frame.size.height = rect->bottom - rect->top;
    frame.origin.x = fullScreenRect.origin.x + rect->left;
    frame.origin.y = fullScreenRect.origin.y + fullScreenRect.size.height - rect->bottom;
    controller.windowFrame = frame;
    runOnMainThread(^{
        [window setFrame:frame display:YES];
    });
    return BDW_SUCCESS;
}

BDWStatus getRectForWindow(NSWindow* window, BDWRect *rect) {
    auto workingScreenRect = controller.workingScreenRect;
    NSRect frame = controller.windowFrame;
    rect->left = frame.origin.x;
    auto frameTop = frame.origin.y + frame.size.height;
    auto workingScreenTop = workingScreenRect.origin.y + workingScreenRect.size.height;
    rect->top = workingScreenTop - frameTop;
    rect->right = rect->left + frame.size.width;
    rect->bottom = rect->top + frame.size.height;
    return BDW_SUCCESS;
}

bool isWindowMaximized(NSWindow* window) {
    return controller.isZoomed;
}

bool isWindowVisible(NSWindow* window) {
    return controller.isVisible;
}

void maximizeOrRestoreWindow(NSWindow* window) {
    runOnMainThread(^{
        [window zoom:nil];
    });
}

void maximizeWindow(NSWindow* window) {
    runOnMainThread(^{
        auto screen = [window screen];
        [window setFrame:[screen visibleFrame] display:true animate:true];
    });
}

void minimizeWindow(NSWindow* window) {
    runOnMainThread(^{
        [window miniaturize:nil];
    });
}

void closeWindow(NSWindow* window) {
    runOnMainThread(^{
        [window close];
    });
}

void setWindowTitle(NSWindow* window, const char* title) {
    NSString *_title = [NSString stringWithUTF8String:title];
    runOnMainThread(^{
        [window setTitle:_title];
    });
}

double getTitleBarHeight(NSWindow* window) {
    return controller.titleBarHeight;
}
