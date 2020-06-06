//
// Created by shdwp on 6/2/2020.
//

#ifndef OPENRUNNER_SLOTVIEW_H
#define OPENRUNNER_SLOTVIEW_H

#include <engine/Entity.h>

class SlotView: public Entity {
    using Entity::Entity;

public:
    string slotid;

    virtual void *itemPointer() { return nullptr; }
};


#endif //OPENRUNNER_SLOTVIEW_H
