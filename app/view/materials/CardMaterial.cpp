//
// Created by shdwp on 5/22/2020.
//

#include "CardMaterial.h"

CardMaterial CardMaterial::Card(const shared_ptr<Texture2D> &tex) {
    auto shader = make_unique<ShaderProgram>(vector<shader_argument_struct>(
            {
                    shader_argument(ShaderType_Vertex, std::string("../app/shaders/card/card_vert.glsl")),
                    shader_argument(ShaderType_Fragment, std::string("../app/shaders/card/card_frag.glsl")),
            }
    ));

    return CardMaterial(move(shader), tex);
}

void CardMaterial::activate(glm::mat4 local) {
    Material::activate(local);

    shader_->uniform("card.x", tile_x);
    shader_->uniform("card.y", tile_y);
    shader_->uniform("card.w", 0.1742f);
    shader_->uniform("card.h", 0.2512f);

    if (tile_tex != nullptr) {
        tile_tex->bind(GL_TEXTURE0 + texture_idx_);
        shader_->uniform("card.tilemap", texture_idx_);
        texture_idx_++;
    }
}

void CardMaterial::deactivate() {
    Material::deactivate();
}
