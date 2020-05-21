//
// Created by shdwp on 5/22/2020.
//

#ifndef OPENRUNNER_GAMEBOARDVIEW_H
#define OPENRUNNER_GAMEBOARDVIEW_H


#include <engine/Entity.h>
#include <unordered_map>
#include "CardView.h"

class GameBoardView: public Entity {
private:
    unique_ptr<std::unordered_map<string, glm::vec3>> slot_positions_;
    unique_ptr<std::unordered_map<string, glm::vec4>> slot_bounding_boxes_;

public:
    explicit GameBoardView(shared_ptr<Model> model);

    void addSlot(const string& slotid, glm::vec3 pos, glm::vec4 bbox = glm::vec4(-1, -1, 1, 1));

    void addCardView(const string& slotid, CardView &view);

    template<class T> shared_ptr<T> getCardView(const string& slotid) {
        for (auto &_child : *children_) {

            auto child = std::dynamic_pointer_cast<CardView>(_child);
            if (child != nullptr && child->slotid == slotid) {
                return std::dynamic_pointer_cast<T>(_child);
            }
        }

        return nullptr;
    }

    void removeCardView(const string& slotid, int idx = 0);

    void update() override;

    void draw(glm::mat4 transform) override;
};


#endif //OPENRUNNER_GAMEBOARDVIEW_H
