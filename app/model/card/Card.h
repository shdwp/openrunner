//
// Created by shdwp on 5/21/2020.
//

#ifndef OPENRUNNER_CARD_H
#define OPENRUNNER_CARD_H


#include <engine/Entity.h>
#include <scripting/LuaHost.h>

class Item {
public:
    string slotid = "";

    virtual ~Item() = default;
};

class Card: public Item {
private:
    static void Copy(Card *a, const Card &b) {
        a->uid = b.uid;
        a->variant = b.variant;
        a->faceup = b.faceup;
        a->highlighted = b.highlighted;
        a->meta = b.meta;
    }

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

        // VERBOSE("MEM +Card constructor {:x} (uid {}, faceup {}, highlighted {})", (size_t)this, this->uid, this->faceup, this->highlighted);
    }

    Card(const Card &card) noexcept : Item(card) {
        Card::Copy(this, card);
        // VERBOSE("MEM +Card copy-constructor {:x} (uid {}, faceup {}, highlighted {})", (size_t)this, this->uid, this->faceup, this->highlighted);
    }

    Card& operator=(const Card &card) noexcept {
        Card::Copy(this, card);
        // VERBOSE("MEM +Card copy-operator {:x} (uid {}, faceup {}, highlighted {})", (size_t)this, this->uid, this->faceup, this->highlighted);
        return *this;
    }

    ~Card() override {
        // VERBOSE("MEM -Card {:x} (uid {}, faceup {}, highlighted {})", (size_t)this, this->uid, this->faceup, this->highlighted);
    }
};


#endif //OPENRUNNER_CARD_H
