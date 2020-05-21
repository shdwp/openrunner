//
// Created by shdwp on 3/17/2020.
//

#ifndef GLPL_RUNTIME_DEBUG_H
#define GLPL_RUNTIME_DEBUG_H

#include <cstdint>

typedef uint32_t runtime_debug_type_t;

enum RuntimeDebugFlags {
    RuntimeDebugFlag_FocusPrintf = 1 >> 0,
    RuntimeDebugFlag_DisplayWireframe = 1 >> 1,
    RuntimeDebugFlag_DisplayNormals = 1 >> 2,
};

#endif //GLPL_RUNTIME_DEBUG_H
