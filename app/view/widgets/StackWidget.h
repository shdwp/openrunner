//
// Created by shdwp on 5/21/2020.
//

#ifndef OPENRUNNER_STACKWIDGET_H
#define OPENRUNNER_STACKWIDGET_H


#include "../board/SlotView.h"

enum stack_widget_orientation {
    StackWidgetOrientation_Horizontal,
    StackWidgetOrientation_Vertical,
};

enum stack_widget_alignment {
    StackWidgetAlignment_Max,
    StackWidgetAlignment_Min,
};

typedef stack_widget_orientation stack_widget_orientation_t;
typedef stack_widget_alignment stack_widget_alignment_t;

class StackWidget: public SlotView {
public:
    using SlotView::SlotView;

    stack_widget_orientation_t orientation = StackWidgetOrientation_Horizontal;
    stack_widget_alignment_t alignment = StackWidgetAlignment_Min;
    glm::vec4 bounding_box = glm::vec4(0, 0, 1, 1);

    void update() override;
};


#endif //OPENRUNNER_STACKWIDGET_H
