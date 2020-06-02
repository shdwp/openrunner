//
// Created by shdwp on 5/21/2020.
//

#ifndef OPENRUNNER_DEFINITIONS_H
#define OPENRUNNER_DEFINITIONS_H

#include <memory>
#include <vector>
#include <map>
#include <string>
#include <algorithm>
#include <iostream>

#include <glad/glad.h>

#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtc/type_ptr.hpp>
#include <glm/gtx/quaternion.hpp>

#include <fmt/core.h>

// TYPEDEFS
typedef unsigned int shader_object_t;
typedef unsigned int program_object_t;
typedef unsigned int texture_object_t;
typedef unsigned int vertex_array_object_t;
typedef unsigned int vertex_buffer_object_t;
typedef unsigned int element_array_buffer_object_t;

// MACRO
#define DEBUG

#define _FORMATTED_PRINT(args...) do { fmt::print(args); std::cout << std::endl; } while (0)

#ifdef DEBUG
    #define INFO(args...) _FORMATTED_PRINT(args)
    #define VERBOSE(args...) _FORMATTED_PRINT(args)
    #define ASSERT(cond, args...) do { if (!cond) _FORMATTED_PRINT(args); assert(cond); } while(0)
    #define FAIL(args...) do { if (!cond) _FORMATTED_PRINT(args); assert(false); } while(0)
#else
    #define INFO(...)
    #define VERBOSE(...)
    #define ASSERT(cond, args...) do {if (!cond) fmt::print(args);} while(0)
    #define FAIL(args...) do {if (!cond) fmt::print(args);} while(0)
#endif

#define ERROR(args...) do{_FORMATTED_PRINT(args);} while(0)

// STD
using std::move;
using std::forward;

using std::begin;
using std::end;
using std::distance;

using std::find;
using std::dynamic_pointer_cast;

using std::unique_ptr;
using std::make_unique;

using std::shared_ptr;
using std::make_shared;

using std::weak_ptr;

using std::vector;

using std::map;

using std::string;

// FMT

using fmt::format;

#endif //OPENRUNNER_DEFINITIONS_H
