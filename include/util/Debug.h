//
// Created by shdwp on 5/23/2020.
//

#ifndef OPENRUNNER_DEBUG_H
#define OPENRUNNER_DEBUG_H

#include <render/ShaderProgram.h>
#include <font/Font.h>
#include <render/Label.h>

#define DEBUG_COLOR_RED glm::vec4(1, 0, 0, 1)
#define DEBUG_COLOR_GREEN glm::vec4(0, 1, 0, 1)
#define DEBUG_COLOR_BLUE glm::vec4(0, 0, 1, 1)
#define DEFAULT_DEBUG_COLOR DEBUG_COLOR_RED

enum DebugDrawOptions {
    DebugDraw_Red = 1 << 0,
    DebugDraw_Green = 1 << 1,
    DebugDraw_Blue = 1 << 2,
    DebugDraw_SS = 1 << 3,
    DebugDraw_WS = 1 << 4,
    DebugDraw_MinW = 1 << 5,
    DebugDraw_SemiTransparent = 1 << 6,
};

typedef unsigned int debug_draw_options_t;

#define DEBUG_DRAW_DEFAULT DebugDraw_Red | DebugDraw_WS

class Debug {
private:
    unique_ptr<ShaderProgram> worldspace_shader_;
    shared_ptr<Font> font_;
    unique_ptr<Label> debug_label_;

    explicit Debug();

    static glm::vec4 colorFromOpts(debug_draw_options_t opts) {
        return glm::vec4(
                opts & DebugDraw_Red ? 1.f : 0.f,
                opts & DebugDraw_Green ? 1.f : 0.f,
                opts & DebugDraw_Blue ? 1.f : 0.f,
                opts & DebugDraw_SemiTransparent ? 0.2f : 1.f
        );
    }

    void drawVBO(VertexBufferObject &vbo, glm::mat4 transform, debug_draw_options_t opts, GLenum mode);

public:
    static Debug *Shared;

    static void Setup() {
        Shared = new Debug();
    }

    void drawPoint(glm::vec3 pos, glm::mat4 transform, debug_draw_options_t opts = DEBUG_DRAW_DEFAULT);

    void drawArea(glm::vec3 a, glm::vec3 b, glm::mat4 transform = glm::identity<glm::mat4>(), debug_draw_options_t opts = DEBUG_DRAW_DEFAULT);

    void drawText(glm::mat4 transform, const string &text, debug_draw_options_t opts = DEBUG_DRAW_DEFAULT);
};


#endif //OPENRUNNER_DEBUG_H
