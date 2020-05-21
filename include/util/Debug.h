//
// Created by shdwp on 5/23/2020.
//

#ifndef OPENRUNNER_DEBUG_H
#define OPENRUNNER_DEBUG_H

#include <render/ShaderProgram.h>

class Debug {
private:
    unique_ptr<ShaderProgram> shader_;
    explicit Debug();

public:
    static Debug *Shared();

    void drawArea(glm::vec3 a, glm::vec3 b, glm::mat4 transform = glm::identity<glm::mat4>());
};


#endif //OPENRUNNER_DEBUG_H
