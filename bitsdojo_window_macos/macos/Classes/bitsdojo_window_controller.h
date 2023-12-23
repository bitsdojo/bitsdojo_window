#import <Cocoa/Cocoa.h>

@interface BitsdojoWindowController : NSObject <NSWindowDelegate>

@property (assign) CGSize windowSize;
@property (assign) bool isVisible;
@property (assign) bool isZoomed;
@property (assign) double titleBarHeight;
@property (nonatomic, weak) NSWindow *window;
@property (assign) NSRect workingScreenRect;
@property (assign) NSRect fullScreenRect;
@property (assign) NSRect windowFrame;

- (instancetype)initWithWindow:(NSWindow *)window;

@end
