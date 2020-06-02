//
// Created by shdwp on 3/14/2020.
//

#ifndef GLPL_SCENE_H
#define GLPL_SCENE_H

#include <render/UniformBufferObject.h>
#include <engine/Entity.h>
#include <util/runtime_debug.h>
#include <ui/UILayer.h>

class Camera;

class Scene: public Entity {
public:
    unique_ptr<UniformBufferObject> uniform_buffer;
    unique_ptr<vector<shared_ptr<Light>>> lights = make_unique<vector<shared_ptr<Light>>>();
    unique_ptr<UILayer> ui_layer;

    runtime_debug_type_t runtime_debug_flags = 0;
    glm::vec2 runtime_debug_focus = glm::vec2(0);

    unique_ptr<Camera> camera;

    Scene(Camera &&camera);

    void bind() const;
    void unbind() const;
};


#endif //GLPL_SCENE_H
