//
// Created by shdwp on 5/21/2020.
//

#ifndef OPENRUNNER_CARD_H
#define OPENRUNNER_CARD_H


#include <engine/Entity.h>
#include <scripting/LuaHost.h>

class Item {
public:
    virtual ~Item() = default;
};

class Card: public Item {
public:
    int uid = 0;
    int variant = 0;
    bool faceup = true;
    bool highlighted = false;
    luabridge::LuaRef meta = nullptr;

    Card(int uid, luabridge::LuaRef meta):
            uid(uid),
            meta(meta)
    {

    }
};


#endif //OPENRUNNER_CARD_H
