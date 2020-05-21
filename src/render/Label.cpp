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
    vector<float> verts;
    vector<float> texcoords;
    vector<uint32_t> indices;
    vector<std::tuple<float, float>> offsets;

    verts.reserve(text.size() * 4);
    texcoords.reserve(text.size() * 4);
    indices.reserve(text.size() * 2);
    offsets.reserve(text.size());

    font_->bake(text, texcoords, offsets);

    float x1 = 0.f;
    float y1 = 0.f;
    int idx = 0;

    for (auto &tuple : offsets) {
        float x2 = x1 + std::get<0>(tuple);
        float y2 = std::get<1>(tuple);

        // top right
        verts.emplace_back(x2);
        verts.emplace_back(y2);
        verts.emplace_back(0.f);

        // bottom right
        verts.emplace_back(x2);
        verts.emplace_back(y1);
        verts.emplace_back(0.f);

        // bottom left
        verts.emplace_back(x1);
        verts.emplace_back(y1);
        verts.emplace_back(0.f);

        // top left
        verts.emplace_back(x1);
        verts.emplace_back(y2);
        verts.emplace_back(0.f);

        /*
        indices.emplace_back(idx);
        indices.emplace_back(idx + 1);
        indices.emplace_back(idx + 3);
        indices.emplace_back(idx + 1);
        indices.emplace_back(idx + 2);
        indices.emplace_back(idx + 3);
         */
        indices.emplace_back(idx + 3);
        indices.emplace_back(idx + 1);
        indices.emplace_back(idx);
        indices.emplace_back(idx + 3);
        indices.emplace_back(idx + 2);
        indices.emplace_back(idx + 1);

        x1 = x2;
        idx += 4;
    }

    vbo_ = make_unique<VertexBufferObject>(verts, texcoords, vector<float>(), indices);
}

void Label::draw() {
    shader_->activate();

    auto trans = glm::identity<glm::mat4>();
    trans = glm::scale(trans, glm::vec3(0.001f));
    trans = glm::rotate(trans, (float)-M_PI_2, glm::vec3(1.f, 0.f, 0.f));

    shader_->uniform("local", trans);

    font_->bind();
    vbo_->bind();
    vbo_->draw();
    vbo_->unbind();
    font_->unbind();

    shader_->deactivate();
}
