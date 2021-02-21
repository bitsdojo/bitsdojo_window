#ifndef BITSDOJO_WINDOW_UTIL_H_
#define BITSDOJO_WINDOW_UTIL_H_

#define WM_BDW_ACTION 0x7FFE

#define BDW_SETWINDOWPOS        1
#define BDW_SETWINDOWTEXT       2
#define BDW_FORCECHILDREFRESH   3

typedef struct _SWPParam {
    int x;
    int y;
    int cx;
    int cy;
    UINT uFlags;
} SWPParam;

typedef struct _SWTParam {
    LPCWSTR text;
} SWTParam;

#endif /* BITSDOJO_WINDOW_UTIL_H_ */ 
