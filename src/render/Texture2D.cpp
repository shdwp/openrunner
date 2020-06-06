//
// Created by shdwp on 3/11/2020.
//

#include "render/Texture2D.h"

#include <iostream>
#include "stb_image/stb_image.h"

Texture2D::Texture2D(uint32_t width, uint32_t height) {
    glGenTextures(1, &gid);
    glBindTexture(GL_TEXTURE_2D, gid);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, width, height, 0, GL_RGB, GL_UNSIGNED_BYTE, NULL);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glBindTexture(GL_TEXTURE_2D, 0);
}

Texture2D::Texture2D(string path, bool flip) {
    int w, h, ch;

    stbi_set_flip_vertically_on_load(flip);

    unsigned char *data = stbi_load(path.c_str(), &w, &h, &ch, 0);
    ASSERT(data, "Failed to load texture {}", path);

    auto type = ch == 4 ? GL_RGBA : GL_RGB;

    /*
    if (w > h) {
        auto new_rows = h - w;
        data = (unsigned char *)realloc(data, w * h * ch + w * new_rows * ch);
        memset(data + w * h * ch, 0, w * new_rows * ch);
    } else if (h > w) {
        auto new_cols = h - w;
        data = (unsigned char *)realloc(data, w * h * ch + h * new_cols * ch);

        for (auto row = 0; row < h; row++) {
            memset(data + row * w + w, 0, new_cols);
        }
    }
     */

    glGenTextures(1, &gid);
    glBindTexture(GL_TEXTURE_2D, gid);
    glTexImage2D(GL_TEXTURE_2D, 0, type, w, h, 0, type, GL_UNSIGNED_BYTE, data);
    glGenerateMipmap(GL_TEXTURE_2D);

    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);

    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);

    stbi_image_free(data);
}

Texture2D::~Texture2D() {
    if (gid != 0) {
        glDeleteTextures(1, &gid);
    }
}
