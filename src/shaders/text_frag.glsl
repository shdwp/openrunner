#version 430 core
#include lib/frag.glsl

uniform sampler2D tex;

void main() {
    Color = texture(tex, TextureCoord);
}
