//
// Created by shdwp on 5/24/2020.
//

#ifndef OPENRUNNER_FONT_H
#define OPENRUNNER_FONT_H

#include <definitions.h>
#include <map>
#include <unordered_map>
#include <ft2build.h>
#include FT_FREETYPE_H

#include <render/Texture2D.h>

struct atlas_meta {
    glm::vec2 origin;
    glm::vec2 size;
    glm::vec2 advance;

    glm::vec2 tex_min;
    glm::vec2 tex_max;
};

typedef struct atlas_meta atlas_meta_t;

class Font {
private:
    FT_Library ft_;
    FT_Face face_;
    unique_ptr<uint8_t[]> atlas_buf_;
    unsigned int atlas_size_ = 0;
    unsigned int atlas_line_height_ = 0;
    unsigned int atlas_x_offset_ = 0, atlas_y_offset_ = 0;
    unsigned int atlas_spacing_ = 5;
    unique_ptr<std::unordered_map<char, atlas_meta_t>> atlas_meta_;

    explicit Font(FT_Library ft, FT_Face face, int size);

public:
    unique_ptr<Texture2D> atlas_tex_;

    unique_ptr<vector<atlas_meta_t>> bake(const string &str);

    void bind() const {
        atlas_tex_->bind();
    }

    void unbind() const {
        atlas_tex_->unbind();
    }

    static Font LoadFace(const string &path, int size);
};


#endif //OPENRUNNER_FONT_H
