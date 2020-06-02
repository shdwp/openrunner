//
// Created by shdwp on 5/24/2020.
//

#ifndef OPENRUNNER_LABEL_H
#define OPENRUNNER_LABEL_H

#include <font/Font.h>
#include <render/VertexBufferObject.h>
#include <render/ShaderProgram.h>
#include <render/Texture2D.h>
#include <engine/Entity.h>

class Label: public Entity {
private:
    unique_ptr<ShaderProgram> shader_;
    shared_ptr<Font> font_;
    unique_ptr<VertexBufferObject> vbo_;

    string text_;

public:
    glm::vec4 color = glm::vec4(1.f);

    explicit Label(shared_ptr<Font> font);

    void setText(const string& text);

    const string &getText() const;

    void draw(glm::mat4 transform) override;
};


#endif //OPENRUNNER_LABEL_H
