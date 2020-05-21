#version 430 core
#include lib/definitions.glsl
layout (location = 0) in vec3 aPos;
out vec3 FragPos;

uniform mat4 local;

void main() {
    FragPos = (local * vec4(aPos, 1)).xyz;
    gl_Position = projection * world * local * vec4(aPos, 1);
}
