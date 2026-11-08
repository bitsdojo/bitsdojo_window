#import "bitsdojo_window_controller.h"

@implementation BitsdojoWindowController

- (instancetype)initWithWindow:(NSWindow *)window {
    self = [super init];
    if (self && window) {
        self.window = window;
        self.window.delegate = self;
        [self onScreenChange];
    }
    return self;
}

- (void)onScreenChange {
    self.isVisible = self.window.isVisible;
    self.isZoomed = self.window.isZoomed;
    [self setupScreenRects];
    [self setupWindowRects];
}

- (void)setupWindowRects {
    self.windowFrame = self.window.frame;
    double windowFrameHeight = self.window.contentView.frame.size.height;
    double contentLayoutHeight = self.window.contentLayoutRect.size.height;
    self.titleBarHeight = windowFrameHeight - contentLayoutHeight;
}

- (void)setupScreenRects {
    NSScreen *screen = self.window.screen;
    self.workingScreenRect = screen.visibleFrame;
    self.fullScreenRect = screen.frame;
}

- (void)windowDidResize:(NSNotification *)notification {
    NSWindow *resizedWindow = notification.object;
    if ([resizedWindow isKindOfClass:[NSWindow class]]) {
        [self setupWindowRects];
        self.windowSize = self.window.frame.size;
    }
}

-(void)handleWindowChanges {
    self.isZoomed = self.window.isZoomed;
}

- (void)windowDidBecomeVisible:(NSNotification *)notification {
    self.isVisible = YES;
}

- (void)windowDidBecomeHidden:(NSNotification *)notification {
    self.isVisible = NO;
}

- (void)windowDidChangeScreen:(NSNotification *)notification {
    [self onScreenChange];
}

- (void)windowDidChangeBackingProperties:(NSNotification *)notification {
    [self onScreenChange];
}

- (void)windowDidMiniaturize:(NSNotification *)notification { [self handleWindowChanges]; }
- (void)windowDidDeminiaturize:(NSNotification *)notification { [self handleWindowChanges]; }
- (void)windowDidEndLiveResize:(NSNotification *)notification { [self handleWindowChanges]; }
@end
