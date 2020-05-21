//
// Created by shdwp on 3/15/2020.
//

#ifndef GLPL_UNIFORMBUFFEROBJECT_H
#define GLPL_UNIFORMBUFFEROBJECT_H

#include "definitions.h"

typedef unsigned int uniform_block_object_t;

class UniformBufferObject {

    unique_ptr<vector<size_t>> offsets_;

public:
    uniform_block_object_t gid;
    UniformBufferObject(uint32_t binding, const vector<size_t> &offsets);

    void bind();

    void unbind();

    void set(uint32_t index, float value);

    void set(uint32_t index, glm::vec3 value);

    void set(uint32_t index, glm::vec2 value);

    void set(uint32_t index, glm::mat4 value);

    void set(uint32_t index, uint8_t *ptr, size_t size);

    void set(uint32_t index, uint32_t value);
};


#endif //GLPL_UNIFORMBUFFEROBJECT_H
