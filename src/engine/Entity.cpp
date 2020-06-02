//
// Created by shdwp on 3/12/2020.
//

#include "engine/Entity.h"
#include <engine/Scene.h>

Entity::Entity(Model &&model) {
    model_ = make_shared<Model>(move(model));
}

Entity::Entity(const shared_ptr<Model> &model) {
    model_ = model;
}

Entity::~Entity() {
    if (children_ != nullptr) {
        for (auto &child : *(children_.get())) {
            child->parent_ = nullptr;
        }
    }
}

void Entity::CopyBasic(Entity *a, const Entity &b) {
    a->model_ = b.model_;
    a->parent_ = b.parent_;
    a->position = b.position;
    a->scale = b.scale;
    a->rotation = b.rotation;
}

void Entity::Copy(Entity *a, const Entity &b) {
    CopyBasic(a, b);
    a->children_ = make_unique<vector<shared_ptr<Entity>>>(*b.children_);

    for (auto &child : *a->children_) {
        child->parent_ = a;
    }
}

void Entity::Move(Entity *a, Entity &b) {
    CopyBasic(a, b);
    a->children_ = make_unique<vector<shared_ptr<Entity>>>(move(*b.children_));

    for (auto &child : *a->children_) {
        child->parent_ = a;
    }
}

void Entity::update() {

}

void Entity::draw(const glm::mat4 transform) {
    if (model_) {
        model_->render(transform);
    }

#ifdef DEBUG_RENDER_INFO
    {
        auto scene = findParent<Scene>();
        auto mat = scene->camera->projection * scene->camera->lookAt() * transform;

        auto ptr = this;
        auto offset = string("");
        while (ptr->parent_ != nullptr) {
            offset.append("\t");
            ptr = ptr->parent_;
        }

        auto origin = mat * glm::vec4(0.f, 0.f, 0.f, 1.f);

        VERBOSE("{} * Entity {} origin {};{};{}",
                offset,
                (size_t)this,
                origin.x,
                origin.y,
                origin.z);
    }
#endif
}

void Entity::updateHierarchy() {
    this->update();

    for (auto &child: *children_) {
        child->updateHierarchy();
    }
}

void Entity::drawHierarchy(const glm::mat4 parentLocal) {
    auto local = this->transform(parentLocal);
    this->draw(local);

    for (auto &child: *children_) {
        child->drawHierarchy(local);
    }
}

void Entity::removeChild(const shared_ptr<Entity> &child) {
    auto pos = find(begin(*children_), end(*children_), child);
    if (pos != end(*children_)) {
        children_->erase(pos);
    }
}

glm::mat4 Entity::transform(const glm::mat4 base) {
    glm::mat4 local = base;

    local = glm::translate(local, position);
    local = local * glm::toMat4(rotation);
    local = glm::scale(local, scale);

    return local;
}

