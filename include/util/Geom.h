//
// Created by shdwp on 6/6/2020.
//

#ifndef OPENRUNNER_GEOM_H
#define OPENRUNNER_GEOM_H

#include <definitions.h>

inline glm::vec4 ascendingYBox(glm::vec3 a, glm::vec3 b) {
    return glm::vec4(
            a.x < b.x ? a.x : b.x,
            a.y < b.y ? a.y : b.y,
            b.x > a.x ? b.x : a.x,
            b.y > a.y ? b.y : a.y
    );
}

inline glm::vec4 ascendingZBox(glm::vec4 box) {
    return ascendingYBox(glm::vec3(box.x, box.y, 0.f), glm::vec3(box.z, box.w, 0.f));
}

inline glm::vec3 vecCenter(glm::vec3 a, glm::vec3 b) {
    return ((b - a) * 0.5f) + a;
}

#endif //OPENRUNNER_GEOM_H
