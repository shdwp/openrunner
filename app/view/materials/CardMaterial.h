//
// Created by shdwp on 5/22/2020.
//

#ifndef OPENRUNNER_CARDMATERIAL_H
#define OPENRUNNER_CARDMATERIAL_H


#include <render/Material.h>

class CardMaterial: public Material {
private:
    using Material::Material;

public:
    static CardMaterial Card(const shared_ptr<Texture2D> &tex);

    shared_ptr<Texture2D> tile_tex = nullptr;
    int tile_x = 0, tile_y = 0;

    void activate(glm::mat4 local) override;

    void deactivate() override;
};


#endif //OPENRUNNER_CARDMATERIAL_H
