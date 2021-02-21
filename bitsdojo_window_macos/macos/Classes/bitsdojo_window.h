#ifndef bitsdojo_window_h
#define bitsdojo_window_h

#include "bitsdojo_window_common.h"

NSWindow* getAppWindow();

typedef NSWindow* (*NSWindowResultFN)();
typedef void (*NSWindowParamFN)(NSWindow*);
typedef void (*BoolParamFN)(bool);
typedef void (*NSWindowIntIntParamFN)(NSWindow*,int, int);
typedef bool (*BoolResultFN)();
typedef BDWStatus (*NSWindowRectParamFN)(NSWindow*, BDWRect*);

void setAppWindow(NSWindow* window);
void setIsWindowReady(bool value);
bool isWindowReady();
void showWindow(NSWindow* window);
void moveWindow(NSWindow* window);
void setSize(NSWindow* window, int width, int height);
void setMinSize(NSWindow* window, int width, int height);
void maximizeWindow(NSWindow* window);

typedef bool (*IsWindowMaximizedFN)(NSWindow* window);
bool isWindowMaximized(NSWindow* window);

BDWStatus getScreenRectForWindow(NSWindow*, BDWRect*);
BDWStatus setRectForWindow(NSWindow*, BDWRect*);
BDWStatus getRectForWindow(NSWindow*, BDWRect*);


#endif /* bitsdojo_window_h */
