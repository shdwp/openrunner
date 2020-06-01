//
// Created by shdwp on 3/11/2020.
//

#include "render/VertexBufferObject.h"

#include <iostream>

VertexBufferObject::VertexBufferObject(const vector<float> &vertices, const vector<float> &tex, const vector<float> &normals, const vector<uint32_t> &indices) {
    glGenVertexArrays(1, &gid);
    glBindVertexArray(gid);

    glGenBuffers(1, &vbo_);
    glBindBuffer(GL_ARRAY_BUFFER, vbo_);
    size_t slot = 0;
    size_t offset = 0;
    size_t total_size = vertices.size() * sizeof(float) + tex.size() * sizeof(float) + normals.size() * sizeof(float);
    glBufferData(GL_ARRAY_BUFFER, total_size, NULL, GL_STATIC_DRAW);

    // vertices
    glBufferSubData(GL_ARRAY_BUFFER, offset, vertices.size() * sizeof(float), (float *)&vertices[0]);
    glVertexAttribPointer(slot, 3, GL_FLOAT, GL_FALSE, sizeof(float) * 3, 0);
    glEnableVertexAttribArray(slot);
    offset += vertices.size() * sizeof(float);
    slot++;

    // tex coords
    if (!tex.empty()) {
        glBufferSubData(GL_ARRAY_BUFFER, offset, tex.size() * sizeof(float), (float *) &tex[0]);
        glVertexAttribPointer(slot, 2, GL_FLOAT, GL_FALSE, sizeof(float) * 2, (void *) offset);
        glEnableVertexAttribArray(slot);
        offset += tex.size() * sizeof(float);
        slot++;
    }

    // normals
    if (!normals.empty()) {
        glBufferSubData(GL_ARRAY_BUFFER, offset, normals.size() * sizeof(float), (float *) &normals[0]);
        glVertexAttribPointer(slot, 3, GL_FLOAT, GL_FALSE, sizeof(float) * 3, (void *) offset);
        glEnableVertexAttribArray(slot);
        offset += normals.size() * sizeof(float);
        slot++;
    }

    if (!indices.empty()) {
        glGenBuffers(1, &ebo_);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, ebo_);
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, indices.size() * sizeof(uint32_t), (uint32_t *) &indices[0],
                     GL_STATIC_DRAW);
        count_ = indices.size();
        defined_indices_ = true;
    } else {
        count_ = vertices.size() / 3;
    }
}

VertexBufferObject::~VertexBufferObject() {
    auto bufs = vector<unsigned int>{vbo_, };
    if (ebo_ != 0) {
        bufs.emplace_back(ebo_);
}

    glDeleteBuffers(bufs.size(), bufs.data());

    if (gid != 0) {
        glDeleteVertexArrays(1, &gid);
    }
}

void VertexBufferObject::bind() {
    glBindVertexArray(gid);
}

void VertexBufferObject::draw(GLenum mode) {
    if (defined_indices_) {
        glDrawElements(mode, count_, GL_UNSIGNED_INT, 0);
    } else {
        glDrawArrays(mode, 0, count_);
    }
}

void VertexBufferObject::unbind() {
    glBindVertexArray(0);
}

