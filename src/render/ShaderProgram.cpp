//
// Created by shdwp on 3/10/2020.
//

#include "render/ShaderProgram.h"

#include <istream>
#include <fstream>
#include <cassert>
#include <sstream>
#include <iostream>

#include <glm/glm.hpp>
#include <glm/gtc/type_ptr.hpp>
#include <Shadinclude/Shadinclude.hpp>
#include <shaderprintf/shaderprintf.h>

shader_object_t load_shader(const string &path, GLenum type) {
    auto contents = Shadinclude::load(path);
    auto contents_ptr = contents.c_str();

    unsigned int shader = glCreateShader(type);
    glShaderSourcePrint(shader, 1, &contents_ptr, NULL);
    glCompileShader(shader);

    int result;
    glGetShaderiv(shader, GL_COMPILE_STATUS, &result);
    if (!result) {
        char infoLog[512];
        glGetShaderInfoLog(shader, 512, NULL, infoLog);
        std::cout << "Failed to compile shader " << path <<  ":\n" << infoLog << std::endl;
        std::cout << "Contents: \n\n" << contents << "\n\n" << std::endl;
    }
    return shader;
}

shader_argument_t shader_argument(shader_argument_type type, std::string path) {
    shader_argument_struct value = {type, path};
    return value;
}

ShaderProgram::ShaderProgram(vector<shader_argument_t> shaders) {
    gid = glCreateProgram();
    print_buffer_ = createPrintBuffer();

    for (shader_argument_t arg: shaders) {
        shader_object_t shader = 0;
        switch (arg.type) {
            case ShaderType_Vertex:
                shader = load_shader(arg.path.c_str(), GL_VERTEX_SHADER);
                break;

            case ShaderType_Fragment:
                shader = load_shader(arg.path.c_str(), GL_FRAGMENT_SHADER);
                break;
        }

        if (shader != 0) {
            glAttachShader(gid, shader);
        } else {
            std::cout << "failed to load shader" << std::endl;
        }
    }

    glLinkProgram(gid);

    int result; glGetProgramiv(gid, GL_LINK_STATUS, &result);
    if (!result) {
        char infoLog[512];
        glGetProgramInfoLog(gid, 512, nullptr, infoLog);
        std::cout << "Failed to link program:\n" << infoLog << std::endl;
    }
}

void ShaderProgram::activate() {
    glUseProgram(gid);
    bindPrintBuffer(gid, print_buffer_);
}

void ShaderProgram::deactivate() {
    auto buffer = getPrintBufferString(print_buffer_);
    if (!buffer.empty()) {
        std::cout << buffer << std::endl << "========================" << std::endl;
    }

    glUseProgram(0);
}

void ShaderProgram::uniform(const char *name, float a) {
    glUniform1f(glGetUniformLocation(gid, name), a);
}

void ShaderProgram::uniform(const char *name, int a) {
    glUniform1i(glGetUniformLocation(gid, name), a);
}

void ShaderProgram::uniform(const char *name, glm::vec3 vec) {
    glUniform3f(glGetUniformLocation(gid, name), vec.x, vec.y, vec.z);
}

void ShaderProgram::uniform(const char *name, glm::vec4 vec) {
    glUniform4f(glGetUniformLocation(gid, name), vec.x, vec.y, vec.z, vec.w);
}

void ShaderProgram::uniform(const char *name, glm::mat3 mat) {
    glUniformMatrix3fv(glGetUniformLocation(gid, name), 1, GL_FALSE, glm::value_ptr(mat));
}

void ShaderProgram::uniform(const char *name, glm::mat4 mat) {
    glUniformMatrix4fv(glGetUniformLocation(gid, name), 1, GL_FALSE, glm::value_ptr(mat));
}
