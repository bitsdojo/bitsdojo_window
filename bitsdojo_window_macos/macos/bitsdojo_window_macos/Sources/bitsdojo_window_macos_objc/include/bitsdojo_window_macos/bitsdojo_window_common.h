#ifndef BITSDOJO_WINDOW_COMMON
#define BITSDOJO_WINDOW_COMMON

typedef struct _BDWRect {
    double left;
    double top;
    double right;
    double bottom;
} BDWRect;

typedef struct _BDWOffset {
    double x;
    double y;
} BDWOffset;

typedef struct _BDWScreenInfo {
    BDWRect* workingRect;
    BDWRect* fullRect;
} BDWScreenInfo;

// 1-byte return status type
typedef signed char BDWStatus;

#define BDW_FAILED  0
#define BDW_SUCCESS 1

#if defined(__cplusplus)
    #define BDW_EXTERN extern "C" 
#else
    #define BDW_EXTERN extern
#endif

#if !defined(BDW_VISIBLE)
    #define BDW_VISIBLE  __attribute__((visibility("default")))
#endif

#if !defined(BDW_EXPORT)
    #define BDW_EXPORT  BDW_EXTERN BDW_VISIBLE
#endif

#endif /* BITSDOJO_WINDOW_COMMON */
