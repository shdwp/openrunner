//
// Created by shdwp on 3/16/2020.
//

#ifndef GLPL_MODEL_H
#define GLPL_MODEL_H


#include <render/VertexBufferObject.h>
#include <render/Material.h>

typedef struct model_zone {
    string identifier;
    glm::vec4 box;
} model_zone;

typedef struct model_zone model_zone_t;

class Model {
public:
    unique_ptr<vector<VertexBufferObject>> buffers;
    unique_ptr<vector<shared_ptr<Material>>> materials;
    unique_ptr<vector<model_zone_t>> zones;

    Model(vector<VertexBufferObject>&&, vector<shared_ptr<Material>>&&, vector<model_zone_t>&&);

    static Model Load(const string &base_path, const string &obj_name, const shared_ptr<Material> &override_mat = nullptr, bool flip_tex = true);

    void render(const glm::mat4 &local);
};


#endif //GLPL_MODEL_H
