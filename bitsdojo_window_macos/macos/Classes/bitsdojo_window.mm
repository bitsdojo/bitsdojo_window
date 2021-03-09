#import "bitsdojo_window.h"

NSWindow* _appWindow = NULL;
bool _windowCanBeShown = false;
bool _insideDoWhenWindowReady = false;

void setInsideDoWhenWindowReady(bool value){
    _insideDoWhenWindowReady = value;
}

void setAppWindow(NSWindow* value){
    _appWindow = value;
}

NSWindow* getAppWindow(){
    if (NULL == _appWindow) {
        _appWindow = [NSApp windows][0];
    }
    return _appWindow;
}

bool windowCanBeShown(){
    return _windowCanBeShown;
}

void setWindowCanBeShown(bool value){
    _windowCanBeShown = value;
}

void showWindow(NSWindow* window) {
    dispatch_async(dispatch_get_main_queue(), ^{
       // [window setIsVisible:TRUE]
        [window makeKeyAndOrderFront:nil];
    });
}

void hideWindow(NSWindow* window) {

    dispatch_async(dispatch_get_main_queue(), ^{
        [window setIsVisible:FALSE];
    });
}

void moveWindow(NSWindow* window) {
    dispatch_async(dispatch_get_main_queue(), ^{
        [window performWindowDragWithEvent:[window currentEvent]];
    }); 
}

void setSize(NSWindow* window, int width, int height){
    NSRect frame = [window frame];
    frame.size.width = width;
    frame.size.height = height;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [window setFrame:frame display:true];
    });
}

void setMinSize(NSWindow* window, int width, int height){
    NSSize minSize;
    minSize.width = width;
    minSize.height = height;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [window setMinSize:minSize];
    });
}

void setMaxSize(NSWindow* window, int width, int height){
    NSSize maxSize;
    maxSize.width = width;
    maxSize.height = height;
    dispatch_async(dispatch_get_main_queue(), ^{
        [window setMaxSize:maxSize];
    });
}

BDWStatus getScreenInfoForWindow(NSWindow* window, BDWScreenInfo *screenInfo){
    auto screen = [window screen];
    auto workingScreenRect = [screen visibleFrame];
    auto fullScreenRect = [screen frame];
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

BDWStatus setPositionForWindow(NSWindow* window, BDWOffset* offset){
    auto block = ^{
        NSPoint position;
        auto screen = [window screen];
        auto fullScreenRect = [screen visibleFrame];
        position.x = offset->x;
        position.y = fullScreenRect.origin.y + fullScreenRect.size.height - offset->y;
        [window setFrameTopLeftPoint:position];
    };

    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
    return BDW_SUCCESS;
}
BDWStatus setRectForWindow(NSWindow* window, BDWRect* rect){
   
    auto block = ^ {
        NSScreen* screen = [window screen];
        NSRect fullScreenRect = [screen frame];
        NSRect frame;
        frame.size.width = rect->right - rect->left;
        frame.size.height = rect->bottom - rect->top;
        frame.origin.x = fullScreenRect.origin.x + rect->left;
        frame.origin.y = fullScreenRect.origin.y + fullScreenRect.size.height - rect->bottom;
        [window setFrame:frame display:TRUE];
    };

    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
    return BDW_SUCCESS;
}

BDWStatus getRectForWindow(NSWindow* window, BDWRect *rect){
    NSScreen* screen = [window screen];
    auto workingScreenRect = [screen visibleFrame];
    NSRect frame = [window frame];
    rect->left = frame.origin.x;
    auto frameTop = frame.origin.y + frame.size.height;
    auto workingScreenTop = workingScreenRect.origin.y + workingScreenRect.size.height;
    rect->top = workingScreenTop - frameTop;
    rect->right = rect->left + frame.size.width;
    rect->bottom = rect->top + frame.size.height;
    return BDW_SUCCESS;
}

bool isWindowMaximized(NSWindow* window){
    return [window isZoomed];
}

bool isWindowVisible(NSWindow* window){
    return [window isVisible];
}

void maximizeOrRestoreWindow(NSWindow* window){
    dispatch_async(dispatch_get_main_queue(), ^{
        [window zoom:nil];
    });
}

void maximizeWindow(NSWindow* window){
    dispatch_async(dispatch_get_main_queue(), ^{
        auto screen = [window screen];
        [window setFrame:[screen visibleFrame] display:true animate:true];
    });
}

void minimizeWindow(NSWindow* window){
    dispatch_async(dispatch_get_main_queue(), ^{
    [window miniaturize:nil];
    });
}

void closeWindow(NSWindow* window){
    dispatch_async(dispatch_get_main_queue(), ^{
        [window close];
    });
}

void setWindowTitle(NSWindow* window, const char* title){
    NSString *_title = [NSString stringWithUTF8String:title];
    dispatch_async(dispatch_get_main_queue(), ^{
        [window setTitle:_title];
    });
}

double getTitleBarHeight(NSWindow* window){
    double windowFrameHeight = window.contentView.frame.size.height;
    double contentLayoutHeight = window.contentLayoutRect.size.height;
    return windowFrameHeight - contentLayoutHeight;
}
