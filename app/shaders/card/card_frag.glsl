#version 430 core
#include ../../../src/shaders/lib/frag.glsl
#include ../runner_definitions.glsl

uniform Card card;

void main() {
    vec4 albedo = texture(material.tex_albedo, TextureCoord);
    Color = albedo;

    if (TextureCoord.x >= 0.9f && TextureCoord.y <= 0.1f) {
        float x = mix(card.x * card.w, (card.x + 1) * card.w, 10.f * (TextureCoord.x - 0.9f));
        float y = mix(card.y * card.h, (card.y + 1) * card.h, 10.f * (TextureCoord.y - 0.1f));
        Color = texture(card.tilemap, vec2(x, y));
    }
}
