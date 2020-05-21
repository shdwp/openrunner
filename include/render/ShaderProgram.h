//
// Created by shdwp on 3/10/2020.
//

#ifndef GLPL_SHADERPROGRAM_H
#define GLPL_SHADERPROGRAM_H

#include "definitions.h"
#include <glm/glm.hpp>

enum shader_argument_type {
    ShaderType_Vertex,
    ShaderType_Fragment
};

struct shader_argument_struct {
    shader_argument_type type;
    string path;
};

typedef shader_argument_struct shader_argument_t;

shader_argument_t shader_argument(shader_argument_type type, string path);

class ShaderProgram {
    GLuint print_buffer_;

public:
    static GLuint PrintBuffer;

    program_object_t gid;

    explicit ShaderProgram(vector<shader_argument_t> shaders);

    void activate();
    void deactivate();

    void uniform(const char *name, int a);
    void uniform(const char *name, float a);

    void uniform(const char *name, glm::vec3 vec);
    void uniform(const char *name, glm::vec4 vec);
    void uniform(const char *name, glm::mat4 mat);
    void uniform(const char *name, glm::mat3 mat);
};


#endif //GLPL_SHADERPROGRAM_H
