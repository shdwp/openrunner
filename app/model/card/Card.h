//
// Created by shdwp on 5/21/2020.
//

#ifndef OPENRUNNER_CARD_H
#define OPENRUNNER_CARD_H


#include <engine/Entity.h>
#include <scripting/LuaHost.h>

class Card {
public:
    int uid = 0;
    int variant = 0;
    bool faceup = true;

    explicit Card(int uid, bool faceup = true) {
        this->uid = uid;
        this->faceup = faceup;
    };

    static void luaRegister(luabridge::Namespace ns);
};


#endif //OPENRUNNER_CARD_H
