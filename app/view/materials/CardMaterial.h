//
// Created by shdwp on 5/22/2020.
//

#ifndef OPENRUNNER_CARDMATERIAL_H
#define OPENRUNNER_CARDMATERIAL_H


#include <render/Material.h>
#include "../../model/card/Card.h"

class CardMaterial: public Material {
private:
    using Material::Material;
    shared_ptr<Texture2D> current_card_tex_ = nullptr;
    unique_ptr<std::unordered_map<int, shared_ptr<Texture2D>>> texture_cache_ = make_unique<std::unordered_map<int, shared_ptr<Texture2D>>>();

public:
    static CardMaterial Material(const shared_ptr<Texture2D> &tex);

    void setupFor(const Card &card);

    void activate(glm::mat4 local) override;

    void deactivate() override;
};


#endif //OPENRUNNER_CARDMATERIAL_H
