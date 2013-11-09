#include <stdio.h>
#include <stdlib.h>
#include "gl_macros.h"

void * MyNSGLGetProcAddress (const char* name) {
  void *symbol = NULL;
  char *symbolName;
  symbolName = malloc(strlen(name) + 2);
  strcpy(symbolName + 1, name);
  symbolName[0] = '_';
  symbol = symbol = (void*)dlsym(RTLD_DEFAULT, symbolName);
  free(symbolName);
  return symbol ? symbol : NULL;
}

