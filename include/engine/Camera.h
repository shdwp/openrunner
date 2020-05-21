//
// Created by shdwp on 3/11/2020.
//

#ifndef GLPL_CAMERA_H
#define GLPL_CAMERA_H

#include "definitions.h"

class Camera {
public:
    glm::mat4 projection;
    glm::vec3 position;
    glm::vec3 direction;

    Camera(glm::mat4 projection, glm::vec3 position, glm::vec3 direction): projection(projection), position(position), direction(direction) { }

    glm::mat4 lookAt() const {
        return glm::lookAt(position, position + direction, glm::vec3(0, 1, 0));
    }
};


#endif //GLPL_CAMERA_H
