//
// Created by shdwp on 6/1/2020.
//

#include "ui/UILayer.h"
#include <engine/Scene.h>
#include <ui/Input.h>
#include <util/Debug.h>

UILayer::UILayer(Scene *scene, glm::mat4 cursor_proj): scene_(scene), cursor_proj(cursor_proj) {
    interactables_ = make_unique<vector<shared_ptr<UIInteractable>>>();
}

shared_ptr<UIInteractable> UILayer::trace(glm::vec2 pos) {
    for (auto &intr : *interactables_) {
        auto zone = intr->getArea(*scene_->camera);

        if (zone.x <= pos.x && zone.y <= pos.y && zone.z >= pos.x && zone.w >= pos.y) {
            return intr;
        }
    }

    return nullptr;
}

shared_ptr<UIInteractable> UILayer::traceInputCursor() {
    auto cursor_pos = glm::vec4((float)Input::Shared->getCursorX(), (float)Input::Shared->getCursorY(), 0.f, 1.f);
    return trace(glm::vec2(cursor_proj * cursor_pos));
}

void UILayer::registerSceneEntity(shared_ptr<Entity> ptr) {
    if (auto interactable_ptr = dynamic_pointer_cast<UIInteractable>(ptr)) {
        auto scene = ptr->findParent<Scene>();
        if (scene != nullptr && scene->ui_layer != nullptr) {
            scene->ui_layer->registerInteractable(interactable_ptr);
        }
    }
}

void UILayer::unregisterSceneEntity(shared_ptr<Entity> ptr) {
    if (auto interactable_ptr = dynamic_pointer_cast<UIInteractable>(ptr)) {
        auto scene = ptr->findParent<Scene>();
        if (scene != nullptr && scene->ui_layer != nullptr) {
            scene->ui_layer->unregisterInteractable(interactable_ptr);
        }
    }
}

void UILayer::debugDraw() {
    for (auto &intr : *interactables_) {
        auto area = intr->getArea(*scene_->camera);
        Debug::Shared->drawArea(
                glm::vec3(area.x, area.y, 0.f),
                glm::vec3(area.z, area.w, 0.f),
                glm::identity<glm::mat4>(),
                DebugDraw_Green | DebugDraw_SS
        );
    }
}
