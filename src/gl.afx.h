#ifndef __GL_AFX_H__
#define __GL_AFX_H__

#if defined(__APPLE__) && !defined(VMDMESA)
#include <OpenGL/gl.h>
#else
#include <GL/gl.h>
#endif
#if defined(GL3_ENABLE)
// #define GLCOREARB_PROTOTYPES
#include "glcorearb.h"
#endif

#endif
