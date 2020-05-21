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

class Font {
private:
    FT_Library ft_;
    FT_Face face_;
    unique_ptr<uint8_t[]> atlas_buf_;
    unsigned int atlas_size_ = 0;
    unsigned int atlas_line_height_ = 0;
    unsigned int atlas_x_offset_ = 0, atlas_y_offset_ = 0;
    unique_ptr<std::unordered_map<char, std::tuple<float, float, float, float, float, float>>> atlas_meta_;

    explicit Font(FT_Library ft, FT_Face face, int size);

public:
    unique_ptr<Texture2D> atlas_tex_;

    void bake(const string &str, vector<float> &texcoords, vector<std::tuple<float, float>> &offsets);

    void bind() const {
        atlas_tex_->bind();
    }

    void unbind() const {
        atlas_tex_->unbind();
    }

    static Font LoadFace(const string &path, int size);
};


#endif //OPENRUNNER_FONT_H
