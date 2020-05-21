//
// Created by shdwp on 3/10/2020.
//

#ifndef GLPL_GL_MISC_H
#define GLPL_GL_MISC_H

#include <glad/glad.h>
#include <GLFW/glfw3.h>

#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtc/type_ptr.hpp>
#include <glm/gtx/quaternion.hpp>

GLenum glCheckError_(const char *file, int line);
#define glCheckError() glCheckError_(__FILE__, __LINE__)

GLFWwindow  *env_setup_window();
void env_setup_debug();

#endif //GLPL_GL_MISC_H
