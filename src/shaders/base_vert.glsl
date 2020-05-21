#version 430 core
#include lib/vert.glsl

void main() {
    gl_Position = calculatePosition();
    Normal = calculateNormal();

    TextureCoord = aTexCoord;
    FragPos = calculateFragPosition().xyz;
}
