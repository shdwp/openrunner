//
// Created by shdwp on 5/21/2020.
//

#include "Card.h"

void Card::luaRegister(luabridge::Namespace ns) {
    ns
            .beginClass<Card>("Card")
            .addConstructor<void (*) (int, bool)>()
            .addProperty("uid", &Card::uid)
            .addProperty("faceup", &Card::faceup)
            .addProperty("variant", &Card::variant)
            .endClass();
}
