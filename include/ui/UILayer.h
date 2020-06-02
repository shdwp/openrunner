//
// Created by shdwp on 6/1/2020.
//

#ifndef OPENRUNNER_UILAYER_H
#define OPENRUNNER_UILAYER_H

#include <unordered_map>
#include <engine/Entity.h>

#include <font/Font.h>
#include <engine/Camera.h>

class Scene;

class UIInteractable {
public:
    virtual glm::vec4 getArea(const Camera &cam) = 0;
    virtual void clicked(glm::vec3 pos) = 0;
};

class UILayer {
private:
    Scene *scene_;
    unique_ptr<std::vector<shared_ptr<UIInteractable>>> interactables_;

public:
    glm::mat4 cursor_proj;

    explicit UILayer(Scene *scene, glm::mat4 cursor_proj);

    template <class T>
    void registerInteractable(T &intr) {
        interactables_->emplace_back(intr);
    }

    template <class T>
    void unregisterInteractable(T &intr) {
        for (auto i = begin(*interactables_); i != end(*interactables_); ++i) {
            if (*i == intr) {
                interactables_->erase(i);
                break;
            }
        }
    }

    void debugDraw();

    shared_ptr<UIInteractable> trace(glm::vec2 pos);

    shared_ptr<UIInteractable> traceInputCursor();

    static void registerSceneEntity(shared_ptr<Entity> ptr);

    static void unregisterSceneEntity(shared_ptr<Entity> ptr);
};


#endif //OPENRUNNER_UILAYER_H
