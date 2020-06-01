#version 430 core
#include lib/frag.glsl

uniform sampler2D tex;
uniform vec4 color;

void main() {
    float alpha = texture(tex, TextureCoord).x * color.a;
    Color = vec4(color.rgb, 1) * alpha;
}
