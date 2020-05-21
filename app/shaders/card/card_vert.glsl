#version 430 core
#include ../../../src/shaders/lib/vert.glsl
#include ../runner_definitions.glsl

void main() {
    gl_Position = calculatePosition();
    Normal = calculateNormal();

    TextureCoord = aTexCoord;
    FragPos = calculateFragPosition().xyz;
}
