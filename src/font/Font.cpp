//
// Created by shdwp on 5/24/2020.
//

#include "font/Font.h"
#include <stb_image/stb_image_write.h>
#include <iostream>

Font::Font(FT_Library ft, FT_Face face, int size) {
    ft_ = ft;
    face_ = face;
    this->size = size;

    atlas_size_ = (size + atlas_spacing_) * 16;
    atlas_buf_ = make_unique<uint8_t[]>(atlas_size_ * atlas_size_);
    memset(atlas_buf_.get(), 0, sizeof(uint8_t) * atlas_size_ * atlas_size_);

    atlas_tex_ = make_unique<Texture2D>(atlas_size_, atlas_size_);
    atlas_meta_ = make_unique<std::unordered_map<char, atlas_meta_t>>();
}

Font Font::LoadFace(const string &path, int size) {
    FT_Library ft;
    ASSERT(!FT_Init_FreeType(&ft), "Failed to init freetype");

    FT_Face face;
    ASSERT(!FT_New_Face(ft, path.c_str(), 0, &face), "Failed to load face");

    FT_Set_Pixel_Sizes(face, 0, size);

    return Font(ft, face, size);
}

unique_ptr<vector<atlas_meta_t>> Font::bake(const string &str) {
    auto result = make_unique<vector<atlas_meta_t>>();
    result->reserve(str.size());

    for (auto ch : str) {
        if (atlas_meta_->find(ch) == atlas_meta_->end()) {
            if (FT_Load_Char(face_, ch, FT_LOAD_RENDER) == 0) {
                auto g = face_->glyph;

                auto atlas_new_x = atlas_x_offset_ + g->bitmap.width + atlas_spacing_;
                if (atlas_new_x > atlas_size_) {
                    atlas_y_offset_ += atlas_line_height_ + atlas_spacing_;
                    atlas_new_x -= atlas_x_offset_;
                    atlas_x_offset_ = 0;
                }

                if (atlas_y_offset_ >= atlas_size_) {
                    ERROR("Not enough space on atlas!");
                    break;
                }

                for (int i = 0; i < g->bitmap.rows; i++) {
                    auto x_offset = atlas_x_offset_;
                    auto y_offset = (atlas_y_offset_ * atlas_size_) + atlas_size_ * i;

                    memcpy(
                            atlas_buf_.get() + x_offset + y_offset,
                            g->bitmap.buffer + g->bitmap.width * i,
                            sizeof(uint8_t) * g->bitmap.width
                    );
                }

                /*
                auto x = calloc(g->bitmap.rows * g->bitmap.width, sizeof(uint8_t));
                memcpy(x, g->bitmap.buffer, g->bitmap.rows * g->bitmap.width * sizeof(uint8_t));

                glTexSubImage2D(GL_TEXTURE_2D, 0, atlas_x_offset_, atlas_y_offset_ / size_, g->bitmap.width, g->bitmap.rows, GL_RED, GL_UNSIGNED_BYTE, x);
                (straight copy was dropped since NV doesn't like NPOT subtex sizes)
                 */

                auto x1 = (float)atlas_x_offset_;
                auto y1 = (float)atlas_y_offset_;
                auto x2 = (float)atlas_x_offset_ + (float)g->bitmap.width;
                auto y2 = (float)atlas_y_offset_ + (float)g->bitmap.rows;

                atlas_meta_t meta = {
                        .origin = glm::vec2(g->bitmap_left, g->bitmap_top),
                        .size = glm::vec2(g->bitmap.width, g->bitmap.rows),
                        .advance = glm::vec2((float)g->advance.x / 64, (float)g->advance.y / 64),
                        .tex_min = glm::vec2(x1 / (float)atlas_size_, y1 / (float)atlas_size_),
                        .tex_max = glm::vec2(x2 / (float)atlas_size_, y2 / (float)atlas_size_),
                };

                atlas_meta_->insert_or_assign(ch, meta);
                atlas_line_height_ = std::max(atlas_line_height_, g->bitmap.rows);
                atlas_x_offset_ = atlas_new_x;

                result->emplace_back(meta);
            } else {
                ERROR("Failed to load char {}", ch);
            }
        } else {
            result->emplace_back(atlas_meta_->at(ch));
        }

    }

    atlas_tex_->bind();
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RED, atlas_size_, atlas_size_, 0, GL_RED, GL_UNSIGNED_BYTE, atlas_buf_.get());
    glGenerateMipmap(GL_TEXTURE_2D);
    atlas_tex_->unbind();

    //auto name = format("atlas_{}.png", (size_t)this);
    //stbi_write_png(name.c_str(), atlas_size_, atlas_size_, 1, atlas_buf_.get(), atlas_size_);

    return result;
}
