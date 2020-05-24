#version 430 core
#include lib/frag.glsl

uniform sampler2D tex;
uniform vec4 color;

void main() {
    Color = texture(tex, TextureCoord).x * color;
}
