#ifndef BITSDOJO_WINDOW_COMMON
#define BITSDOJO_WINDOW_COMMON

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


#endif