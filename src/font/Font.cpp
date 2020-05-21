//
// Created by shdwp on 5/24/2020.
//

#include "font/Font.h"
#include <stb_image/stb_image_write.h>
#include <iostream>

Font::Font(FT_Library ft, FT_Face face, int size) {
    ft_ = ft;
    face_ = face;

    atlas_size_ = size * 16;
    atlas_buf_ = make_unique<uint8_t[]>(atlas_size_ * atlas_size_);
    memset(atlas_buf_.get(), 0, sizeof(uint8_t) * atlas_size_ * atlas_size_);

    atlas_tex_ = make_unique<Texture2D>(atlas_size_, atlas_size_);
    atlas_meta_ = make_unique<std::unordered_map<char, std::tuple<float, float, float, float, float, float>>>();
}

Font Font::LoadFace(const string &path, int size) {
    FT_Library ft;
    ASSERT(!FT_Init_FreeType(&ft), "Failed to init freetype");

    FT_Face face;
    ASSERT(!FT_New_Face(ft, path.c_str(), 0, &face), "Failed to load face");

    FT_Set_Pixel_Sizes(face, 0, size);

    return Font(ft, face, size);
}

void Font::bake(const string &str, vector<float> &texcoords, vector<std::tuple<float, float>> &offsets) {
    for (auto ch : str) {
        std::tuple<float, float, float, float, float, float> meta;
        if (atlas_meta_->find(ch) == atlas_meta_->end()) {
            if (FT_Load_Char(face_, ch, FT_LOAD_RENDER) == 0) {
                auto g = face_->glyph;

                if (atlas_x_offset_ + g->bitmap.width > atlas_size_) {
                    atlas_y_offset_ += atlas_line_height_ * atlas_size_ + 10;
                    atlas_x_offset_ = 0;
                }

                if (atlas_y_offset_ > atlas_size_) {
                    ERROR("Not enough space on atlas!");
                    break;
                }

                for (int i = 0; i < g->bitmap.rows; i++) {
                    auto x_offset = atlas_x_offset_;
                    auto y_offset = atlas_y_offset_ + atlas_size_ * i;

                    memcpy(
                            atlas_buf_.get() + x_offset + y_offset,
                            g->bitmap.buffer + g->bitmap.width * i,
                            sizeof(uint8_t) * g->bitmap.width
                    );
                }

                auto x = calloc(g->bitmap.rows * g->bitmap.width, sizeof(uint8_t));
                memcpy(x, g->bitmap.buffer, g->bitmap.rows * g->bitmap.width * sizeof(uint8_t));

                /*
                  glTexSubImage2D(GL_TEXTURE_2D, 0, atlas_x_offset_, atlas_y_offset_ / size_, g->bitmap.width, g->bitmap.rows, GL_RED, GL_UNSIGNED_BYTE, x);
                  (straight copy was dropped since NV doesn't like NPOT subtex sizes)
                 */

                float x1 = (float)atlas_x_offset_;
                float y1 = (float)atlas_y_offset_;
                float x2 = (float)atlas_x_offset_ + (float)g->bitmap.width;
                float y2 = (float)atlas_y_offset_ + (float)g->bitmap.rows;

                meta = std::tuple<float, float, float, float, float, float>(
                        x1 / (float)atlas_size_,
                        y1 / (float)atlas_size_,
                        x2 / (float)atlas_size_,
                        y2 / (float)atlas_size_,
                        g->bitmap.width,
                        g->bitmap.rows
                );

                atlas_meta_->insert_or_assign(ch, meta);
                atlas_line_height_ = std::max(atlas_line_height_, g->bitmap.rows);
                atlas_x_offset_ += g->bitmap.width + 10;
            } else {
                ERROR("Failed to load char {}", ch);
            }
        } else {
            meta = (*atlas_meta_)[ch];
        }

        texcoords.emplace_back(std::get<2>(meta));
        texcoords.emplace_back(std::get<1>(meta));

        texcoords.emplace_back(std::get<2>(meta));
        texcoords.emplace_back(std::get<3>(meta));

        texcoords.emplace_back(std::get<0>(meta));
        texcoords.emplace_back(std::get<3>(meta));

        texcoords.emplace_back(std::get<0>(meta));
        texcoords.emplace_back(std::get<1>(meta));

        offsets.emplace_back(std::tuple<float, float>(
                std::get<4>(meta),
                std::get<5>(meta)
        ));
    }

    atlas_tex_->bind();
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RED, atlas_size_, atlas_size_, 0, GL_RED, GL_UNSIGNED_BYTE, atlas_buf_.get());
    glGenerateMipmap(GL_TEXTURE_2D);
    atlas_tex_->unbind();

    /*
    stbi_write_png("../assets/atlas.png", atlas_size_, atlas_size_, 1, atlas_buf_.get(), atlas_size_);
     */
}
