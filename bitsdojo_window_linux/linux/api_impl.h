#ifndef _BDW_API_IMPL_
#define _BDW_API_IMPL_

#include <gtk/gtk.h>

namespace bitsdojo_window {

    typedef void (*TGetScreenRect)(GtkWindow*, int*, int*, int*, int*);
    void getScreenRect(GtkWindow* window, int* x, int* y, int* width, int* height );

    typedef void (*TGetScaleFactor)(GtkWindow*, int*);
    void getScaleFactor(GtkWindow* window, int* scaleFactor);

    typedef void (*TGetPosition)(GtkWindow*, int*, int*);
    void getPosition(GtkWindow* window, int* x, int* y);

    typedef void (*TSetPosition)(GtkWindow*, int, int);
    void setPosition(GtkWindow* window, int x, int y);

    typedef void (*TGetSize)(GtkWindow*, int*, int*);
    void getSize(GtkWindow* window, int* width, int* height);

    typedef void (*TSetSize)(GtkWindow*, int, int);
    void setSize(GtkWindow* window, int width, int height);

    typedef void (*TSetRect)(GtkWindow*, int, int, int, int);
    void setRect(GtkWindow* window, int x, int y, int width, int height);

    typedef void (*TSetMinSize)(GtkWindow*, int, int);
    void setMinSize(GtkWindow* window, int width, int height);
    
    typedef void (*TSetMaxSize)(GtkWindow*, int, int);
    void setMaxSize(GtkWindow* window, int width, int height);

    typedef void (*TShowWindow)(GtkWindow*);
    void showWindow(GtkWindow* window);

    typedef void (*THideWindow)(GtkWindow*);
    void hideWindow(GtkWindow* window);

    typedef void (*TMinimizeWindow)(GtkWindow*);
    void minimizeWindow(GtkWindow* window); 

    typedef void (*TMaximizeWindow)(GtkWindow*);
    void maximizeWindow(GtkWindow* window);  

    typedef void (*TUnmaximizeWindow)(GtkWindow*);
    void unmaximizeWindow(GtkWindow* window);

    typedef void (*TSetWindowTitle)(GtkWindow*, const gchar *);
    void setWindowTitle(GtkWindow* window, const gchar *title);

    typedef void (*TSetTopmost)(GtkWindow*, int);
    void setTopmost(GtkWindow* window,int topmost);
}

#endif // _BDW_API_IMPL_
