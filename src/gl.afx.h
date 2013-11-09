#ifndef __GL_AFX_H__
#define __GL_AFX_H__

#if defined(__APPLE__) && !defined(VMDMESA)
  #include <OpenGL/gl.h>
  #include <OpenGL/glext.h>
  #include <OpenGL/gl3.h>
  #include <OpenGL/gl3ext.h>
#else
  #include <GL/gl.h>
  #include <GL/glext.h>
  #include <GL/glx.h>
  #include <GL/glxext.h>
#endif /* if defined(__APPLE__) && !defined(VDMESA) */
#if defined(GL3_ENABLE)
  #include "glcorearb.h"
#endif  // defined(GL3_ENABLE)

#include "gl_macros.h"

#endif
