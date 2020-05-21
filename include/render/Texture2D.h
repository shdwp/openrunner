//
// Created by shdwp on 3/11/2020.
//

#ifndef GLPL_TEXTURE2D_H
#define GLPL_TEXTURE2D_H


#include <string>
#include "definitions.h"

class Texture2D {
public:
    texture_object_t gid;

    explicit Texture2D(uint32_t width, uint32_t height);
    explicit Texture2D(string path, bool flip = true);

    void bind(GLenum unit = GL_TEXTURE0) {
        glActiveTexture(unit);
        glBindTexture(GL_TEXTURE_2D, gid);
    }

    static void unbind(GLenum unit = GL_TEXTURE0) {
        glActiveTexture(unit);
        glBindTexture(GL_TEXTURE_2D, 0);
    }
};


#endif //GLPL_TEXTURE2D_H
