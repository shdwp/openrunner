//
// Created by shdwp on 3/11/2020.
//

#ifndef GLPL_VERTEXBUFFEROBJECT_H
#define GLPL_VERTEXBUFFEROBJECT_H

#include "definitions.h"

class VertexBufferObject {
private:
    size_t count_ = 0;
    bool defined_indices_ = false;

    vertex_buffer_object_t vbo_ = 0;
    element_array_buffer_object_t ebo_ = 0;

public:
    vertex_array_object_t gid = 0;

    explicit VertexBufferObject(
            const vector<float> &vertices,
            const vector<float> &tex = vector<float>(),
            const vector<float> &normals = vector<float>(),
            const vector<uint32_t> &indices = vector<uint32_t>()
            );

    void bind();
    void draw(GLenum mode = GL_TRIANGLES);
    void unbind();
};


#endif //GLPL_VERTEXBUFFEROBJECT_H
