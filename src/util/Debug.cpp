//
// Created by shdwp on 5/23/2020.
//

#include "util/Debug.h"
#include <render/VertexBufferObject.h>

Debug::Debug() {
    shader_ = make_unique<ShaderProgram>(vector<shader_argument_struct>(
            {
                    shader_argument(ShaderType_Vertex, std::string("../src/shaders/debug_vert.glsl")),
                    shader_argument(ShaderType_Fragment, std::string("../src/shaders/debug_frag.glsl")),
            }
    ));
}

void Debug::drawArea(glm::vec3 a, glm::vec3 b, glm::mat4 transform) {
    auto vbo = VertexBufferObject({
        a.x,
        a.y,
        a.z,

        b.x,
        b.y,
        b.z
    });

    shader_->activate();
    shader_->uniform("local", transform);
    vbo.bind();

    {
        glDisable(GL_DEPTH_TEST);
        vbo.draw(GL_LINES);
        glEnable(GL_DEPTH_TEST);
    }

    vbo.unbind();
    shader_->deactivate();
}

Debug *Debug::Shared() {
    static Debug instance = Debug();
    return &instance;
}

