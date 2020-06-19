//
// Created by shdwp on 6/1/2020.
//

#include "ui/UILayer.h"
#include <engine/Scene.h>
#include <ui/Input.h>
#include <util/Debug.h>
#include <util/Geom.h>

UILayer::UILayer(Scene *scene, glm::mat4 cursor_proj): scene_(scene), cursor_proj(cursor_proj) {
    interactables_ = make_unique<vector<shared_ptr<UIInteractable>>>();
}

shared_ptr<UIInteractable> UILayer::trace(glm::vec2 pos) {
    shared_ptr<UIInteractable> result = nullptr;
    int max_z_index = INT32_MIN;

    for (auto i = interactables_->rbegin(); i != interactables_->rend(); i++) {
        auto intr = *i;
        auto interactableZone = intr->interactableArea();
        auto zone = project(std::get<0>(interactableZone), std::get<1>(interactableZone));
        auto z_index = std::get<2>(interactableZone);

        if (zone.x <= pos.x && zone.y <= pos.y && zone.z >= pos.x && zone.w >= pos.y) {
            if (max_z_index < z_index) {
                result = intr;
                max_z_index = z_index;
            }
        }
    }

    return result;
}

shared_ptr<UIInteractable> UILayer::traceInputCursor() {
    auto cursor_pos = glm::vec4((float)Input::Shared->getCursorX(), (float)Input::Shared->getCursorY(), 0.f, 1.f);
    return trace(glm::vec2(cursor_proj * cursor_pos));
}

glm::vec4 UILayer::project(glm::vec4 localA, glm::vec4 localB) {
    auto clipA = scene_->camera->projection * scene_->camera->lookAt() * localA;
    auto clipB = scene_->camera->projection * scene_->camera->lookAt() * localB;

    auto a = glm::vec3(clipA) / clipA.w;
    auto b = glm::vec3(clipB) / clipB.w;

    return ascendingYBox(a, b);
}

UILayer *UILayer::layerFor(const Entity *ptr) {
    auto scene = ptr->findParent<Scene>();
    if (scene != nullptr && scene->ui_layer != nullptr) {
        return scene->ui_layer.get();
    }

    return nullptr;
}

void UILayer::registerSceneEntity(shared_ptr<Entity> ptr) {
    if (auto interactable_ptr = dynamic_pointer_cast<UIInteractable>(ptr)) {
        if (auto layer = layerFor(ptr.get())) {
            layer->registerInteractable(interactable_ptr);
        }
    }
}

void UILayer::unregisterSceneEntity(shared_ptr<Entity> ptr) {
    if (auto interactable_ptr = dynamic_pointer_cast<UIInteractable>(ptr)) {
        if (auto layer = layerFor(ptr.get())) {
            layer->unregisterInteractable(interactable_ptr);
        }
    }
}

void UILayer::debugDraw() {
    for (auto &intr : *interactables_) {
        auto interactableZone = intr->interactableArea();
        auto area = project(std::get<0>(interactableZone), std::get<1>(interactableZone));

        Debug::Shared->drawArea(
                glm::vec3(area.x, area.y, 0.f),
                glm::vec3(area.z, area.w, 0.f),
                glm::identity<glm::mat4>(),
                DebugDraw_Green | DebugDraw_SS
        );
    }
}
