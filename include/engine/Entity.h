//
// Created by shdwp on 3/12/2020.
//

#ifndef GLPL_GOBJECT_H
#define GLPL_GOBJECT_H

#include <definitions.h>
#include <engine/Camera.h>
#include <render/Model.h>

class Entity;

class Entity {
private:
    static void CopyBasic(Entity *a, const Entity &b);
    static void Copy(Entity *a, const Entity &b);
    static void Move(Entity *a, Entity &b);

protected:
    shared_ptr<Model> model_ = nullptr;
    Entity *parent_ = nullptr;
    unique_ptr<vector<shared_ptr<Entity>>> children_ = make_unique<vector<shared_ptr<Entity>>>();

public:
    glm::vec3 position = glm::vec3(0.f);
    glm::vec3 scale = glm::vec3(1.f);
    glm::quat rotation = glm::quat(0.f, 0.f, 0.f, 0.f);

    bool hidden = false;

    explicit Entity() = default;
    explicit Entity(const shared_ptr<Model> &model);
    explicit Entity(Model &&model);

    Entity(const Entity &o) noexcept {
        Copy(this, o);
    }

    Entity(Entity &&o) noexcept {
        Move(this, o);
    }

    Entity& operator=(const Entity &o) noexcept {
        Copy(this, o);
        return *this;
    }

    Entity& operator=(Entity &&o) noexcept {
        Move(this, o);
        return *this;
    }

    ~Entity();

    virtual string debugDescription() { return format("E{:x}", (size_t)this); }

    virtual void update();

    virtual void draw(glm::mat4 transform);

    void updateHierarchy();
    void drawHierarchy(glm::mat4 parentLocal);

    glm::mat4 transform(glm::mat4 base = glm::mat4(1));

    template<class T>
    const T* findParent() const {
        if (auto instance = dynamic_cast<const T *>(this)) {
            return instance;
        } else if (this->parent_ == nullptr) {
            return nullptr;
        } else {
            return this->parent_->findParent<T>();
        }
    }

    template<class T>
    shared_ptr<T> addChild(T &&child) {
        child.parent_= this;
        auto ptr = make_shared<T>(move(child));
        children_->emplace_back(ptr);

        return ptr;
    }

    template<class T>
    void addChild(shared_ptr<T> child) {
        child->parent_= this;
        children_->emplace_back(child);
    }

    void removeChild(const shared_ptr<Entity> &child);

    void removeChild(const int idx) {
        children_->erase(children_->begin() + idx);
        auto fn = [](float a){};
    }

    template <typename T>
    void removeChild(T pred) {
        for (auto i = begin(*children_); i != end(*children_); i++) {
            if (pred(*i) == true) {
                children_->erase(i);
                break;
            }
        }
    }

    shared_ptr<Entity> childAt(size_t idx) {
        return children_->at(idx);
    }

    size_t childCount() {
        return children_->size();
    }
};

#endif //GLPL_GOBJECT_H
