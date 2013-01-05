#ifndef __GL_AFX_H__
#define __GL_AFX_H__

#if defined(__APPLE__) && !defined(VMDMESA)
#include <OpenGL/gl.h>
#if defined(GL3_ENABLE)
#include <OpenGL/gl3.h>
#endif
#else
#include <GL/gl.h>
#if defined(GL3_ENABLE)
#include <GL3/gl3.h>
#endif
#endif

#endif
