#version 430 core
#include lib/definitions.glsl
layout (location = 0) in vec3 aPos;
out vec3 FragPos;

uniform mat4 local;
uniform bool screenspace;

void main() {
    FragPos = (local * vec4(aPos, 1.f)).xyz;
    gl_Position = local * vec4(aPos, 1.f);

    if (!screenspace) {
        gl_Position = projection * world * gl_Position;
    }
}
