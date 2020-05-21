//
// Created by shdwp on 3/13/2020.
//

#include "render/Material.h"

#include <engine/Camera.h>

Material::Material(unique_ptr<ShaderProgram> mShader, const shared_ptr<Texture2D> &_tex_albedo) {
    shader_ = move(mShader);
    tex_albedo = _tex_albedo;
}

Material Material::Base(glm::vec4 albedo) {
    auto shader = make_unique<ShaderProgram>(vector<shader_argument_struct>(
            {
                    shader_argument(ShaderType_Vertex, std::string("../src/shaders/base_vert.glsl")),
                    shader_argument(ShaderType_Fragment, std::string("../src/shaders/base_frag.glsl")),
            }
    ));

    auto mat = Material(move(shader), nullptr);
    mat.albedo = albedo;
    return mat;
}

void Material::activate(glm::mat4 local) {
    texture_idx_ = 1;

    shader_->activate();

    shader_->uniform("local", local);

    if (tex_albedo) {
        tex_albedo->bind(GL_TEXTURE0 + texture_idx_);
        shader_->uniform("material.has_albedo", true);
        shader_->uniform("material.tex_albedo", texture_idx_);
        texture_idx_++;
    }

    if (tex_spec) {
        tex_spec->bind(GL_TEXTURE0 + texture_idx_);
        shader_->uniform("material.has_spec", true);
        shader_->uniform("material.tex_spec", texture_idx_);
        texture_idx_++;
    }

    if (tex_emission) {
        tex_emission->bind(GL_TEXTURE0 + texture_idx_);
        shader_->uniform("material.has_emission", true);
        shader_->uniform("material.tex_emission", texture_idx_);
        texture_idx_++;
    }

    if (tex_sheen) {
        tex_sheen->bind(GL_TEXTURE0 + texture_idx_);
        shader_->uniform("material.has_sheen", true);
        shader_->uniform("material.tex_sheen", texture_idx_);
        texture_idx_++;
    }

    shader_->uniform("material.col_albedo", albedo);
    shader_->uniform("material.val_emission", emission);
}

void Material::deactivate() {
    shader_->deactivate();
}
