#version 430 core
#include lib/definitions.glsl

uniform vec4 color;

in vec3 FragPos;
out vec4 Color;

void main() {
    Color = color;
}
