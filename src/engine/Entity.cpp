//
// Created by shdwp on 3/12/2020.
//

#include "engine/Entity.h"

Entity::Entity(Model &&model) {
    model_ = make_shared<Model>(move(model));
}

Entity::Entity(const shared_ptr<Model> &model) {
    model_ = model;
}

void Entity::update() {

}

void Entity::draw(const glm::mat4 transform) {
    if (model_) {
        model_->render(transform);
    }
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

