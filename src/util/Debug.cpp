//
// Created by shdwp on 5/23/2020.
//

#include "util/Debug.h"

Debug* Debug::Shared;

Debug::Debug() {
    shader_ = make_unique<ShaderProgram>(vector<shader_argument_struct>(
            {
                    shader_argument(ShaderType_Vertex, std::string("../src/shaders/debug_vert.glsl")),
                    shader_argument(ShaderType_Fragment, std::string("../src/shaders/debug_frag.glsl")),
            }
    ));

    font_ = make_shared<Font>(Font::LoadFace("../assets/fonts/Roboto-Medium.ttf", 18));
    debug_label_ = make_unique<Label>(font_);
    debug_label_->color = glm::vec4(1, 0, 0, 1);
}

void Debug::drawVBO(VertexBufferObject &vbo, glm::mat4 transform, glm::vec4 color, GLenum mode) {
    shader_->activate();
    shader_->uniform("local", transform);
    shader_->uniform("color", color);
    vbo.bind();

    {
        glDisable(GL_DEPTH_TEST);
        glDisable(GL_CULL_FACE);
        vbo.draw(mode);
        glEnable(GL_DEPTH_TEST);
        glEnable(GL_CULL_FACE);
    }

    vbo.unbind();
    shader_->deactivate();
}

void Debug::drawArea(glm::vec3 a, glm::vec3 b, glm::mat4 transform, glm::vec4 color) {
    auto vbo = VertexBufferObject({
        a.x,
        a.y,
        a.z,

        b.x,
        b.y,
        b.z
    });

    this->drawVBO(vbo, transform, color, GL_LINES);

}

void Debug::drawPoint(glm::vec3 pos, glm::mat4 transform, glm::vec4 color) {
    auto vbo = VertexBufferObject({
        pos.x, pos.y, pos.z
    });

    this->drawVBO(vbo, transform, color, GL_POINTS);
}

void Debug::drawText(glm::mat4 transform, const string &text, glm::vec4 color) {
    debug_label_->setText(text);
    debug_label_->color = color;

    {
        glDisable(GL_DEPTH_TEST);
        glDisable(GL_CULL_FACE);
        debug_label_->draw(transform);
        glEnable(GL_DEPTH_TEST);
        glEnable(GL_CULL_FACE);
    }
}

