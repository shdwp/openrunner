//
// Created by shdwp on 5/24/2020.
//

#ifndef OPENRUNNER_PRIMITIVES_H
#define OPENRUNNER_PRIMITIVES_H

#define RECT_DATA (vector<float>){\
     0.5f,  0.5f, 0.0f, /* top right */\
     0.5f, -0.5f, 0.0f, /* bottom right */\
    -0.5f, -0.5f, 0.0f, /* bottom left */\
    -0.5f,  0.5f, 0.0f  /* top left */ \
}

#define RECT_TEX (vector<float>){\
     1.f, 1.f, /* top right */\
     1.f, 0.f, /* bottom right */\
    0.f, 0.f, /* bottom left */\
    0.f, 1.f /* top left */\
}

#define RECT_INDICES (vector<uint32_t>){\
    0, 1, 3,   /* first triangle */\
    1, 2, 3    /* second triangle */\
}

#endif //OPENRUNNER_PRIMITIVES_H
