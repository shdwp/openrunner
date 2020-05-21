#version 430 core
#include lib/definitions.glsl

in vec2 TextureCoord;
in vec3 Normal;
in vec3 FragPos;
out vec4 Color;

uniform Material material;

void main() {
    vec4 albedo = texture(material.tex_albedo, TextureCoord);
    Color = albedo;
}
