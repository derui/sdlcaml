/* This implements OpenGL wrapper for OCaml APIs are higher than OpenGL3.0. */

/* define macros for getting process address of some functions.   */
#ifdef _WIN32                           /* for windows */
#include <windows.h>
#include <glext.h>

#define CHECK_ADDRESS(func, proto) \
  static proto func = NULL; \
  static unsigned int func##_is_loaded = 0; \
  if (!func##_is_loaded) { \
    func = (proto) wglGetProcAddress(#func); \
    if (func == NULL) { caml_failwith("Unable to load " #func);} \
    else func##_is_loaded = 1; \
  }
#else  /* for MacOS X */
#if defined(__APPLE__) && !defined(VMDMESA)
#include <dlfcn.h>
#include <string.h>

void * MyNSGLGetProcAddress (const char* name);

#define CHECK_FUNC(func, proto)

#else /* for *nix. */

/* If using nVidia, do not this need? */
#define CHECK_FUNC(func, proto) \
  static proto func = NULL; \
  static unsigned int func##_is_loaded = 0; \
  if (!func##_is_loaded) { \
    func = (proto) glXGetProcAddress(#func); \
    if (func == NULL) { caml_failwith("Unable to load " #func);} \
    else func##_is_loaded = 1; \
  }
#endif
#endif
