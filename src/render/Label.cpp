//
// Created by shdwp on 5/24/2020.
//

#include <render/Label.h>

Label::Label(shared_ptr<Font> font) {
    font_ = font;
    shader_ = make_unique<ShaderProgram>(vector<shader_argument_struct>(
            {
                    shader_argument(ShaderType_Vertex, std::string("../src/shaders/base_vert.glsl")),
                    shader_argument(ShaderType_Fragment, std::string("../src/shaders/text_frag.glsl")),
            }
    ));
}

void Label::setText(const string &text) {
    text_ = text;

    vector<float> verts;
    vector<float> texcoords;
    vector<uint32_t> indices;

    verts.reserve(text.size() * 4);
    texcoords.reserve(text.size() * 4);
    indices.reserve(text.size() * 2);

    auto chars_meta = font_->bake(text);

    float x1 = 0.f;
    int idx = 0;

    for (auto &meta : *chars_meta) {
        float x2 = x1 + meta.size.x;
        float y1 = meta.origin.y - meta.size.y;
        float y2 = y1 + meta.size.y;

        // top right
        verts.emplace_back(x2);
        verts.emplace_back(y2);
        verts.emplace_back(0.f);
        texcoords.emplace_back(meta.tex_max.x);
        texcoords.emplace_back(meta.tex_min.y);

        // bottom right
        verts.emplace_back(x2);
        verts.emplace_back(y1);
        verts.emplace_back(0.f);
        texcoords.emplace_back(meta.tex_max.x);
        texcoords.emplace_back(meta.tex_max.y);

        // bottom left
        verts.emplace_back(x1);
        verts.emplace_back(y1);
        verts.emplace_back(0.f);
        texcoords.emplace_back(meta.tex_min.x);
        texcoords.emplace_back(meta.tex_max.y);

        // top left
        verts.emplace_back(x1);
        verts.emplace_back(y2);
        verts.emplace_back(0.f);
        texcoords.emplace_back(meta.tex_min.x);
        texcoords.emplace_back(meta.tex_min.y);

        // indices
        indices.emplace_back(idx + 3);
        indices.emplace_back(idx + 1);
        indices.emplace_back(idx);
        indices.emplace_back(idx + 3);
        indices.emplace_back(idx + 2);
        indices.emplace_back(idx + 1);

        x1 += meta.advance.x;
        idx += 4;
    }

    vbo_ = make_unique<VertexBufferObject>(verts, texcoords, vector<float>(), indices);
}

const string &Label::getText() const {
    return text_;
}

void Label::draw(glm::mat4 trans) {
    shader_->activate();

    shader_->uniform("local", trans);
    shader_->uniform("color", color);

    font_->bind();
    vbo_->bind();
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    vbo_->draw();
    glDisable(GL_BLEND);
    vbo_->unbind();
    font_->unbind();

    shader_->deactivate();
}
