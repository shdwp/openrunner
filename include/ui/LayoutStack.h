//
// Created by shdwp on 6/19/20.
//

#ifndef OPENRUNNER_LAYOUTSTACK_H
#define OPENRUNNER_LAYOUTSTACK_H


#include <engine/Entity.h>

enum LayoutStackOrientation {
    LayoutStackOrientation_Vertical,
    LayoutStackOrientation_Horizontal,
};

typedef LayoutStackOrientation layout_stack_orientation_t;

class ILayout: public Entity {
public:
    float layoutWidth = -1.f;
    float layoutHeight = -1.f;
};

class LayoutStack: public Entity {
public:
    layout_stack_orientation_t orientation = LayoutStackOrientation_Vertical;

    void update() override;
};


#endif //OPENRUNNER_LAYOUTSTACK_H
