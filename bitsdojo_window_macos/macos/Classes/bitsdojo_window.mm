#import "bitsdojo_window.h"


NSWindow* _appWindow = NULL;
bool _isWindowReady = false;

void setAppWindow(NSWindow* value){
    _appWindow = value;
}
NSWindow* getAppWindow(){
    return _appWindow;
}

bool isWindowReady(){
    return _isWindowReady;
}

void setIsWindowReady(bool value){
    _isWindowReady = value;

}

void showWindow(NSWindow* window) {
    dispatch_async(dispatch_get_main_queue(), ^{
        [window makeKeyAndOrderFront:window];
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

BDWStatus getScreenRectForWindow(NSWindow* window, BDWRect *rect){
    /* dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    __block NSScreen* screen;
    
    if ([NSThread isMainThread]) {
        screen = [window screen];
    } else
        dispatch_sync(mainQueue, ^{
            screen = [window screen];
        });
    */
    auto screen = [window screen];
    auto screenRect = [screen frame];
    rect->left = screenRect.origin.x;
    rect->top = screenRect.origin.y;
    rect->right = rect->left + screenRect.size.width;
    rect->bottom = rect->top + screenRect.size.height;
    return BDW_SUCCESS;
}

BDWStatus setRectForWindow(NSWindow* window, BDWRect *rect){
    NSRect frame;
    frame.origin.x = rect->left;
    frame.origin.y = rect->top;
    frame.size.width = rect->right - rect->left;
    frame.size.height = rect->bottom - rect->top;
    if ([NSThread isMainThread]) {
        [window setFrame:frame display:TRUE];
    } else
    dispatch_async(dispatch_get_main_queue(), ^{
        [window setFrame:frame display:TRUE];
    });
    return BDW_SUCCESS;
}

BDWStatus getRectForWindow(NSWindow* window, BDWRect *rect){
    
    /*__block NSRect frame;
    if ([NSThread isMainThread]) {
        frame = [window frame];
    } else
    dispatch_sync(dispatch_get_main_queue(), ^{
        frame = [window frame];
    });*/
    NSRect frame = [window frame];
    rect->left = frame.origin.x;
    rect->top = frame.origin.y;
    rect->right = rect->left + frame.size.width;
    rect->bottom = rect->top + frame.size.height;
    return BDW_SUCCESS;
}

bool isWindowMaximized(NSWindow* window){
    return [window isZoomed];
}

void maximizeWindow(NSWindow* window){
    dispatch_async(dispatch_get_main_queue(), ^{
    [window zoom:nil];
    });
}

