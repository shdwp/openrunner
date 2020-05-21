//
// Created by shdwp on 3/15/2020.
//

#include "render/UniformBufferObject.h"

UniformBufferObject::UniformBufferObject(uint32_t binding, const vector<size_t> &offsets) {
    offsets_ = make_unique<vector<size_t>>(offsets);
    auto size = offsets_->back();
    offsets_->pop_back();

    glGenBuffers(1, &gid);

    glBindBuffer(GL_UNIFORM_BUFFER, gid);

    glBufferData(GL_UNIFORM_BUFFER, size, NULL, GL_DYNAMIC_DRAW);
    glBindBufferRange(GL_UNIFORM_BUFFER, binding, gid, 0, size);

    glBindBuffer(GL_UNIFORM_BUFFER, 0);
}

void UniformBufferObject::bind() {
    glBindBuffer(GL_UNIFORM_BUFFER, gid);
}

void UniformBufferObject::unbind() {
    glBindBuffer(GL_UNIFORM_BUFFER, 0);
}

void UniformBufferObject::set(uint32_t index, float value) {
    glBufferSubData(GL_UNIFORM_BUFFER, (*offsets_)[index], sizeof(value), &value);
}

void UniformBufferObject::set(uint32_t index, uint32_t value) {
    glBufferSubData(GL_UNIFORM_BUFFER, (*offsets_)[index], sizeof(value), &value);
}

void UniformBufferObject::set(uint32_t index, glm::vec3 value) {
    glBufferSubData(GL_UNIFORM_BUFFER, (*offsets_)[index], sizeof(value), glm::value_ptr(value));
}

void UniformBufferObject::set(uint32_t index, glm::mat4 value) {
    glBufferSubData(GL_UNIFORM_BUFFER, (*offsets_)[index], sizeof(value), glm::value_ptr(value));
}

void UniformBufferObject::set(uint32_t index, uint8_t *ptr, size_t size) {
    glBufferSubData(GL_UNIFORM_BUFFER, (*offsets_)[index], size, ptr);
}

void UniformBufferObject::set(uint32_t index, glm::vec2 value) {
    glBufferSubData(GL_UNIFORM_BUFFER, (*offsets_)[index], sizeof(value), &value);
}
