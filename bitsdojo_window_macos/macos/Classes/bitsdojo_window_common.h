#ifndef BITSDOJO_WINDOW_COMMON
#define BITSDOJO_WINDOW_COMMON

typedef struct _BDWRect {
    double left;
    double top;
    double right;
    double bottom;
} BDWRect;

// 1-byte return status type
typedef signed char BDWStatus;

#define BDW_FAILED  0
#define BDW_SUCCESS 1

#endif /* BITSDOJO_WINDOW_COMMON */