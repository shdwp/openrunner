//
// Created by shdwp on 5/22/2020.
//

#include "CardMaterial.h"

CardMaterial CardMaterial::Material(const shared_ptr<Texture2D> &tex) {
    auto card_shader = make_shared<ShaderProgram>(vector<shader_argument_struct>(
            {
                    shader_argument(ShaderType_Vertex, std::string("../app/shaders/card/card_vert.glsl")),
                    shader_argument(ShaderType_Fragment, std::string("../app/shaders/card/card_frag.glsl")),
            }
    ));

    auto highlight_shader = make_shared<ShaderProgram>(vector<shader_argument_struct>(
            {
                    shader_argument(ShaderType_Vertex, std::string("../app/shaders/card/card_vert.glsl")),
                    shader_argument(ShaderType_Fragment, std::string("../app/shaders/card/card_highlight_frag.glsl")),
            }
    ));

    return CardMaterial(card_shader, highlight_shader, tex);
}

void CardMaterial::activate(glm::mat4 local) {
    Material::activate(local);

    if (current_card_tex_ != nullptr) {
        current_card_tex_->bind(GL_TEXTURE0 + texture_idx_);
        shader_->uniform("card.tex", texture_idx_);
        texture_idx_++;
    }
}

void CardMaterial::deactivate() {
    Material::deactivate();
}

void CardMaterial::setupFor(const Card &card) {
    if (auto existing_tex = (*texture_cache_)[card.uid]) {
        current_card_tex_ = existing_tex;
    } else {
        auto new_tex = make_shared<Texture2D>(format("../assets/cards/{}.jpg", card.uid), false);
        (*texture_cache_)[card.uid] = new_tex;
        current_card_tex_ = new_tex;
    }

    shader_ = card_shader_;
}

void CardMaterial::setupForHighlight() {
    shader_ = highlight_shader_;
}
