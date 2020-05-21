//
// Created by shdwp on 3/13/2020.
//

#ifndef GLPL_MATERIAL_H
#define GLPL_MATERIAL_H


#include "ShaderProgram.h"
#include "Texture2D.h"

class Light;
class Scene;
class Camera;

class Material {
protected:
    unique_ptr<ShaderProgram> shader_;
    int texture_idx_;

public:
    shared_ptr<Texture2D> tex_albedo;
    shared_ptr<Texture2D> tex_emission;
    shared_ptr<Texture2D> tex_spec;
    shared_ptr<Texture2D> tex_sheen;

    glm::vec4 albedo = glm::vec4(0);
    float emission = 0.f;

    Material(unique_ptr<ShaderProgram> mShader, const shared_ptr<Texture2D> &m_albedo);

    static Material Base(glm::vec4 albedo);

    virtual void activate(glm::mat4 local);
    virtual void deactivate();
};


#endif //GLPL_MATERIAL_H
