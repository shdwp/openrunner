//
// Created by shdwp on 5/23/2020.
//

#include "util/Debug.h"
#include "render/Primitives.h"

Debug* Debug::Shared;

Debug::Debug() {
    worldspace_shader_ = make_unique<ShaderProgram>(vector<shader_argument_struct>(
            {
                    shader_argument(ShaderType_Vertex, std::string("../src/shaders/debug_vert.glsl")),
                    shader_argument(ShaderType_Fragment, std::string("../src/shaders/debug_frag.glsl")),
            }
    ));

    font_ = make_shared<Font>(Font::LoadFace("../assets/fonts/Roboto-Medium.ttf", 14));
    debug_label_ = make_unique<Label>(font_);
    debug_label_->scale = glm::vec3(0.002f);
    debug_label_->rotation = glm::rotate(debug_label_->rotation, glm::vec3((float)-M_PI_2, 0.f, 0.f));
    debug_label_->color = glm::vec4(1, 0, 0, 1);
}

void Debug::drawVBO(VertexBufferObject &vbo, glm::mat4 transform, debug_draw_options_t opts, GLenum mode) {
    ShaderProgram *shader = worldspace_shader_.get();

    shader->activate();
    shader->uniform("local", transform);
    shader->uniform("color", Debug::colorFromOpts(opts));
    shader->uniform("screenspace", opts & DebugDraw_SS ? true : false);
    shader->uniform("minw", opts & DebugDraw_MinW ? true : false);
    vbo.bind();

    {
        glEnable(GL_BLEND);
        glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
        glDisable(GL_DEPTH_TEST);
        glDisable(GL_CULL_FACE);
        vbo.draw(mode);
        glEnable(GL_DEPTH_TEST);
        glEnable(GL_CULL_FACE);
        glDisable(GL_BLEND);
    }

    vbo.unbind();
    shader->deactivate();
}

void Debug::drawArea(glm::vec3 a, glm::vec3 b, glm::mat4 transform, debug_draw_options_t opts) {
    auto vbo = VertexBufferObject({
        a.x,
        a.y,
        a.z,

        a.x,
        b.y,
        a.z,

        b.x,
        b.y,
        b.z,

        b.x,
        a.y,
        b.z,
    }, {}, {}, {0,1,3, 1,2,3});

    this->drawVBO(vbo, transform, opts | DebugDraw_SemiTransparent, GL_TRIANGLES);
}

void Debug::drawPoint(glm::vec3 pos, glm::mat4 transform, debug_draw_options_t opts) {
    auto vbo = VertexBufferObject({
        pos.x, pos.y, pos.z
    });

    this->drawVBO(vbo, transform, opts, GL_POINTS);
}

void Debug::drawText(glm::mat4 transform, const string &text, debug_draw_options_t opts) {
    debug_label_->setText(text);
    debug_label_->color = Debug::colorFromOpts(opts);

    {
        glDisable(GL_DEPTH_TEST);
        glDisable(GL_CULL_FACE);
        debug_label_->drawHierarchy(transform);
        glEnable(GL_DEPTH_TEST);
        glEnable(GL_CULL_FACE);
    }
}

