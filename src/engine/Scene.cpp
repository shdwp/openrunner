//
// Created by shdwp on 3/14/2020.
//

#include "engine/Scene.h"
#include "engine/Camera.h"

Scene::Scene(Camera &&cam, glm::mat4 cursor_proj) {
    uniform_buffer = make_unique<UniformBufferObject>(0, (vector<size_t>) {
        0, // projection mat4
        64, // world mat4
        128, // view position vec3
        144, // debug cursor pos vec3
        152, // debug opts int
    });

    camera = make_unique<Camera>(cam);
    ui_layer = make_unique<UILayer>(this, cursor_proj);
}

void Scene::bind() const {
    uniform_buffer->bind();

    uniform_buffer->set(0, camera->projection);
    uniform_buffer->set(1, camera->lookAt());
    uniform_buffer->set(2, camera->position);
    /*
    this->uniform_buffer->set(3, runtime_debug_focus);
    this->uniform_buffer->set(4, runtime_debug_flags);
     */
    /*
    this->uniform_buffer->set(5, static_cast<uint32_t>(lights->size()));

    unsigned int i = 6;
    for (auto &light: *this->lights) {
        uint8_t lightStruct[SHADER_LIGHT_STRUCT_SIZE];
        light->shaderStruct(lightStruct);
        this->uniform_buffer->set(i++, lightStruct, SHADER_LIGHT_STRUCT_SIZE);
    }
     */
}

void Scene::unbind() const {
    this->uniform_buffer->unbind();
}

void Scene::reset() {
    children_->erase(children_->begin(), children_->end());
    ui_layer = make_unique<UILayer>(this, ui_layer->cursor_proj);
}
