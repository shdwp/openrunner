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

    static void Move(VertexBufferObject *a, VertexBufferObject &b) noexcept {
        a->count_ = b.count_;
        a->defined_indices_ = b.defined_indices_;
        a->vbo_ = b.vbo_;
        a->ebo_ = b.ebo_;
        a->gid = b.gid;

        b.vbo_ = 0;
        b.ebo_ = 0;
        b.gid = 0;
    }

public:
    vertex_array_object_t gid = 0;

    explicit VertexBufferObject(
            const vector<float> &vertices,
            const vector<float> &tex = vector<float>(),
            const vector<float> &normals = vector<float>(),
            const vector<uint32_t> &indices = vector<uint32_t>()
            );

    VertexBufferObject(VertexBufferObject &&o) noexcept {
        Move(this, o);
    }

    VertexBufferObject& operator=(VertexBufferObject &&o) noexcept {
        Move(this, o);
        return *this;
    }

    ~VertexBufferObject();

    void bind();
    void draw(GLenum mode = GL_TRIANGLES);
    void unbind();
};


#endif //GLPL_VERTEXBUFFEROBJECT_H
