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

class Debug {
private:
    unique_ptr<ShaderProgram> shader_;
    shared_ptr<Font> font_;
    unique_ptr<Label> debug_label_;

    explicit Debug();

    void drawVBO(VertexBufferObject &vbo, glm::mat4 transform, glm::vec4 color, GLenum mode);

public:
    static Debug *Shared;

    static void Setup() {
        Shared = new Debug();
    }

    void drawPoint(glm::vec3 pos, glm::mat4 transform, glm::vec4 color = DEFAULT_DEBUG_COLOR);
    void drawArea(glm::vec3 a, glm::vec3 b, glm::mat4 transform = glm::identity<glm::mat4>(), glm::vec4 color = DEFAULT_DEBUG_COLOR);
    void drawText(glm::mat4 transform, const string &text, glm::vec4 color = DEFAULT_DEBUG_COLOR);
};


#endif //OPENRUNNER_DEBUG_H
